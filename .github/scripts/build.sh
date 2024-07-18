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
    --image "${DOCKERHUB_USER}/hyperion-ng-addon-amd64:2.0.16" \
    --release-tag \
    --no-latest \
    --${ARCH:-all}
