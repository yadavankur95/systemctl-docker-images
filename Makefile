ROOTDIR := $(shell pwd)

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

version:
	test -n "$(VERSION)"  # $$BUILD_VERSION

build-centos: version		       	## To build CentOS
	docker build --build-arg version=${VERSION} -t yadavankur95/centos:${VERSION} -f ./centos/Dockerfile .

push-centos: build-centos   		## Push CentOS image to registry
	docker push yadavankur95/centos:${VERSION}

build-centos-stream: version		## To build Stream CentOS
	docker build --build-arg version=${VERSION} -t yadavankur95/centos-stream:${VERSION} -f ./centos-stream/Dockerfile .

push-centos-stream: build-centos   	## Push Stream CentOS image to registry
	docker push yadavankur95/centos-stream:${VERSION}

build-ubuntu: version			## To build Ubuntu
	docker build --build-arg version=${VERSION} -t yadavankur95/ubuntu:${VERSION} -f ./ubuntu/Dockerfile .

push-ubuntu: build-ubuntu   		## Push Ubuntu image to registry
	docker push yadavankur95/ubuntu:${VERSION}

build-redhat: version      		## To build redhat image
	$(eval version_major := $(shell echo $(VERSION) | awk -F'.' '{print $$1}'))
	docker build --build-arg version=$(VERSION) --build-arg version_major=$(version_major) -t yadavankur95/redhat:$(VERSION) -f ./redhat/Dockerfile .

push-redhat: build-redhat   		## Push redhat image to registry
	docker push yadavankur95/redhat:${VERSION}

build-almalinux: version		## To build almalinux
	docker build --build-arg version=${VERSION} -t yadavankur95/almalinux:${VERSION} -f ./almalinux/Dockerfile .

push-almalinux: build-almalinux   	## Push almalinux image to registry
	docker push yadavankur95/almalinux:${VERSION}

build-debian: version			## To build debain
	docker build --build-arg version=${VERSION} -t yadavankur95/debian:${VERSION} -f ./debian/Dockerfile .

push-debian: build-debian   		## Push debain image to registry
	docker push yadavankur95/debian:${VERSION}
