
IMAGE_NAME=steveayre/sipp

VERSION=3.6.1
BUILD_NUMBER=2

.PHONY: image
image:
	docker build \
		--progress=plain \
		--build-arg VERSION=${VERSION} --build-arg BUILD_NUMBER=${BUILD_NUMBER} \
		-t ${IMAGE_NAME}:${VERSION}-${BUILD_NUMBER} \
		-t ${IMAGE_NAME}:latest \
		.

