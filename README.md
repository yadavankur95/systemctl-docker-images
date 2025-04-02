# Docker Systemd Images

A collection of Docker images with systemd support, enabling the use of `systemctl` and other systemd functions within containers.

## Overview

This project provides Docker images for various Linux distributions with systemd properly configured as PID 1, allowing you to:

- Run systemd services inside containers
- Use `systemctl` commands as you would on a normal host
- Create containers that more closely resemble full virtual machines
- Test service configurations in an isolated environment

## Supported Distributions

The following distributions are currently supported:

- CentOS (7.x, 8.x)
- CentOS Stream (8)
- Red Hat Enterprise Linux (8.x, 9.x)
- Ubuntu (22.04, 24.04)
- AlmaLinux (8.x, 9.x)
- Debian (12, latest)

## Prerequisites

- Docker installed on your host system
- Appropriate permissions to run Docker containers with privileged mode

## Usage

### Basic Usage

Pull an image:

```bash
docker pull yadavankur95/centos:7
```

Run a container with systemd as PID 1:
- with CG
```bash
docker run -d --name centos7-systemd \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  yadavankur95/centos:7
```
- without CG
```bash
docker run -d --name centos7-systemd \
  --privileged \
  yadavankur95/centos:7
```

Connect to the running container:

```bash
docker exec -it centos7-systemd bash
```

Now you can use `systemctl` commands inside the container:

```bash
systemctl status
systemctl list-units
```

### Distribution-Specific Examples

#### Ubuntu 22.04

```bash
docker run -d --name ubuntu-systemd \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  yadavankur95/ubuntu:22.04
```

#### RHEL 9

```bash
docker run -d --name rhel-systemd \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  yadavankur95/redhat:9
```

## Building the Images

You can build these images yourself using the included Makefile.

### Build a specific image:

```bash
VERSION=7 make build-centos
```

### Push a specific image:

```bash
VERSION=7 make push-centos
```

### Available make targets:

- `build-centos`: Build CentOS images
- `build-centos-stream`: Build CentOS Stream images
- `build-ubuntu`: Build Ubuntu images
- `build-redhat`: Build RedHat images
- `build-almalinux`: Build AlmaLinux images
- `build-debain`: Build Debian images
- `push-*`: Push respective images to Docker registry

## Building Multiple Versions

Use the included shell script to build multiple versions of each image:

```bash
./build-and-push-multiple.sh
```

## Custom Entrypoint

If you need specific initialization steps for a particular distribution, you can create a custom entrypoint script:

1. Create a file named `custom-entrypoint-[distro].sh` (e.g., `custom-entrypoint-centos.sh`)
2. Make it executable: `chmod +x custom-entrypoint-centos.sh`

You can mount the script during the runtime or create a custom image (Check Sample for example)

## Technical Details

### How Systemd Works as PID 1

Systemd needs to run as PID 1 inside the container to function properly. This requires:

1. Running the container with `--privileged` flag
2. Mounting the host's cgroup filesystem (optional)
3. Special Dockerfile configurations to initialize systemd correctly

### Dockerfile Structure

Each distribution's Dockerfile follows this general pattern:

```dockerfile
FROM [base-distribution]:[version]

# Install systemd
RUN [distribution-specific commands]

# Remove unnecessary services, configure systemd
RUN [configuration commands]

# Set the default command to start systemd
CMD ["/usr/sbin/init"]
```

## Use Cases

- Testing services that require systemd
- Creating development environments that match production systems
- Automating tests that require service control
- Training environments for system administration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
