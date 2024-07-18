#!/bin/sh
set -e
ARCH=$1

# Build the image
docker run --rm --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v ${GITHUB_WORKSPACE}/addon-hyperion-ng:/data \
    homeassistant/amd64-builder \
    --target /data \
    --docker-user "${DOCKER_USER}" \
    --docker-password "${DOCKER_PASSWORD}" \
    --no-latest \
    --${ARCH:-all}

# Tag and save the image locally
IMAGE_NAME=$(docker images --filter=reference='bradsjm/hyperion-ng-addon-*' --format "{{.Repository}}:{{.Tag}}" | head -n 1)
NEW_IMAGE_NAME="addon-hyperion-ng-images/hyperion-ng-addon-${ARCH}:${GITHUB_SHA}"
docker tag ${IMAGE_NAME} ${NEW_IMAGE_NAME}
docker save ${NEW_IMAGE_NAME} > ${GITHUB_WORKSPACE}/saved-images/hyperion-ng-addon-${ARCH}-${GITHUB_SHA}.tar
