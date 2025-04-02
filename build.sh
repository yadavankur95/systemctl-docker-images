#!/bin/bash

# Build and push script for Docker images
# This script builds and pushes multiple versions of each Docker image type

# Define versions for each distribution type (space-separated lists)
CENTOS_VERSIONS="7 8"
CENTOS_STREAM_VERSIONS="8"
UBUNTU_VERSIONS="22.04 24.04"
REDHAT_VERSIONS="8.9 9.2"
ALMALINUX_VERSIONS="8 9"
DEBIAN_VERSIONS="12 latest"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Docker image build and push process for multiple versions...${NC}"

# Function to build and push a specific image with version
build_and_push() {
    local IMAGE_TYPE=$1
    local VERSION=$2
    
    echo -e "\n${BLUE}=== Building $IMAGE_TYPE image with version $VERSION ===${NC}"
    
    # Build the image using make
    if VERSION=$VERSION make build-$IMAGE_TYPE; then
        echo -e "${GREEN}Successfully built $IMAGE_TYPE:$VERSION${NC}"
        
        # Push the image
        echo "Pushing $IMAGE_TYPE:$VERSION to registry..."
        if VERSION=$VERSION make push-$IMAGE_TYPE; then
            echo -e "${GREEN}Successfully pushed $IMAGE_TYPE:$VERSION${NC}"
        else
            echo -e "${RED}Failed to push $IMAGE_TYPE:$VERSION${NC}"
            FAILED_IMAGES+=("$IMAGE_TYPE:$VERSION - push failed")
            return 1
        fi
    else
        echo -e "${RED}Failed to build $IMAGE_TYPE:$VERSION${NC}"
        FAILED_IMAGES+=("$IMAGE_TYPE:$VERSION - build failed")
        return 1
    fi
    
    SUCCESSFUL_IMAGES+=("$IMAGE_TYPE:$VERSION")
    return 0
}

# Arrays to track results
SUCCESSFUL_IMAGES=()
FAILED_IMAGES=()

# Process multiple versions for each image type
process_image_type() {
    local IMAGE_TYPE=$1
    local VERSIONS=$2
    
    echo -e "\n${YELLOW}Processing $IMAGE_TYPE with versions: $VERSIONS${NC}"
    
    for VERSION in $VERSIONS; do
        build_and_push "$IMAGE_TYPE" "$VERSION"
    done
}

# Process all image types with their respective versions
process_image_type "centos" "$CENTOS_VERSIONS"
process_image_type "centos-stream" "$CENTOS_STREAM_VERSIONS"
process_image_type "ubuntu" "$UBUNTU_VERSIONS"
process_image_type "redhat" "$REDHAT_VERSIONS"
process_image_type "almalinux" "$ALMALINUX_VERSIONS"
process_image_type "debian" "$DEBIAN_VERSIONS" 

# Check if all images are available in local Docker
echo -e "\n${YELLOW}Verifying local images:${NC}"
docker images | grep "yadavankur95"

# Print summary
echo -e "\n${YELLOW}=== BUILD AND PUSH SUMMARY ===${NC}"
echo -e "${GREEN}Successfully built and pushed (${#SUCCESSFUL_IMAGES[@]}):"
for image in "${SUCCESSFUL_IMAGES[@]}"; do
    echo -e "  ✓ $image"
done

if [ ${#FAILED_IMAGES[@]} -gt 0 ]; then
    echo -e "\n${RED}Failed images (${#FAILED_IMAGES[@]}):"
    for image in "${FAILED_IMAGES[@]}"; do
        echo -e "  ✗ $image"
    done
    echo -e "${NC}Check logs above for specific error details."
    exit 1
else
    echo -e "\n${GREEN}All images built and pushed successfully!${NC}"
fi