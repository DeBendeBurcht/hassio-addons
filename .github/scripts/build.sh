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

# Extract the built image name
IMAGE_NAME=$(docker images --filter=reference='bradsjm/hyperion-ng-addon-*' --format "{{.Repository}}:{{.Tag}}" | head -n 1)
NEW_IMAGE_NAME="${DOCKER_USER}/hyperion-ng-addon-${ARCH}:${GITHUB_SHA}"

# Tag the image with the correct repository name
docker tag ${IMAGE_NAME} ${NEW_IMAGE_NAME}

# Push the image to Docker Hub
docker push ${NEW_IMAGE_NAME}
