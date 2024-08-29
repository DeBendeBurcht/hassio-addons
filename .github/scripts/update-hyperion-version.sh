#!/bin/sh

BASE=${GITHUB_WORKSPACE}/addon-hyperion-ng

FILE="${BASE}/config.json"
CURRENT="$(jq -r ".version" $FILE)"

echo "VERSION=${CURRENT}" >> $GITHUB_ENV

REPO="https://github.com/hyperion-project/hyperion.ng.git"

# Retrieve the latest beta version
RELEASE="$(git ls-remote --tags ${REPO} | grep 'beta' | cut -d/ -f3- | sort -V | tail -n1)"

echo "RELEASE=${RELEASE}" >> $GITHUB_ENV

if [ "${CURRENT}" != "${RELEASE}" ]; then
    jq ".version=\"${RELEASE}\"" $FILE > $FILE.tmp
    mv $FILE.tmp $FILE
fi
