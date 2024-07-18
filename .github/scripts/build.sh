#!/bin/sh
set -e
ARCH=$1

# Build the image
docker run --rm --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v ${GITHUB_WORKSPACE:-$(PWD)}/addon-hyperion-ng:/data \
    homeassistant/amd64-builder \
    --target /data \
    --docker-user "${DOCKERHUB_USER}" \
    --docker-password "${DOCKERHUB_PASSWORD}" \
    --no-latest \
    --${ARCH:-all}

# Extract the built image name
IMAGE_NAME=$(docker images --filter=reference="${DOCKERHUB_USER}/hyperion-ng-addon-*" --format "{{.Repository}}:{{.Tag}}" | head -n 1)
NEW_IMAGE_NAME="${DOCKERHUB_USER}/hyperion-ng-addon-${ARCH}:${GITHUB_SHA}"

# Tag the image with the correct repository name
docker tag ${IMAGE_NAME} ${NEW_IMAGE_NAME}

# Docker login using the correct Docker Hub credentials
echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USER}" --password-stdin

# Push the image to Docker Hub
docker push ${NEW_IMAGE_NAME}
