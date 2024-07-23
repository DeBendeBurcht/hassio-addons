#!/bin/sh
set -e
ARCH=$1

# Ensure correct path and mounting
docker run --rm --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v ${GITHUB_WORKSPACE:-$(PWD)}/addon-hyperion-ng:/data \
    homeassistant/amd64-builder \
    --target /data \
    --target /home/user/myrepo/build
    --test \
    --${ARCH:-all}
