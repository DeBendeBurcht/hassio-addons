#!/bin/sh
set -e
ARCH=$1

# Build the image
docker run --rm --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v ${GITHUB_WORKSPACE:-$(PWD)}/addon-hyperion-ng:/data \
    homeassistant/amd64-builder \
    --target /data \
    --docker-user "${DOCKER_USER}" \
    --docker-password "${DOCKER_PASSWORD}" \
    --no-latest \
    --${ARCH:-all}

# Define the image name
IMAGE_NAME="hyperion-ng-addon-${ARCH}"
FULL_IMAGE_NAME="${DOCKER_USER}/${IMAGE_NAME}:latest"

# Tag the image with the correct repository name
docker tag ${IMAGE_NAME}:latest ${FULL_IMAGE_NAME}

# Push the image to Docker Hub
docker push ${FULL_IMAGE_NAME}
