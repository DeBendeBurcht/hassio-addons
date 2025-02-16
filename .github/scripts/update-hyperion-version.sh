#!/bin/sh

BASE=${GITHUB_WORKSPACE}/addon-hyperhdr

FILE="${BASE}/config.json"
CURRENT="$(jq -r ".version" $FILE)"

echo "VERSION=${CURRENT}" >> $GITHUB_ENV

REPO_API="https://api.github.com/repos/awawa-dev/HyperHDR/releases/latest"
RELEASE="$(curl --silent ${REPO_API} | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//' )" # extract latest release version

# REPO="https://github.com/awawa-dev/HyperHDR.git"
# RELEASE="$(git ls-remote --sort='v:refname' --tags ${REPO} | cut -d/ -f3- | tail -n1)"

echo "RELEASE=${RELEASE}" >> $GITHUB_ENV

if [ "${CURRENT}" != "${RELEASE}" ]; then
    jq ".version=\"${RELEASE}\"" $FILE > $FILE.tmp
    mv $FILE.tmp $FILE
fi
