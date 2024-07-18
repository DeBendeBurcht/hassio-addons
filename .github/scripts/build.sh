#!/bin/sh
set -e
ARCH=$1

docker run --rm --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v ${GITHUB_WORKSPACE:-$(PWD)}/addon-hyperion-ng:/data \
    homeassistant/amd64-builder \
    --target /data \
    --docker-user "${DOCKERHUB_USER}" \
    --docker-password "${DOCKERHUB_PASSWORD}" \
    --no-latest \
    --${ARCH:-all}
