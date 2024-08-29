#!/bin/sh

BASE=${GITHUB_WORKSPACE}/addon-hyperion-ng
FILE="${BASE}/config.json"
CURRENT="$(jq -r ".version" $FILE)"

# Define the GitHub repository and the specific run ID
REPO="hyperion-project/hyperion.ng"
RUN_ID="10539641052"  # The specific run ID from the URL

# Get a GitHub personal access token (PAT) with the necessary permissions
GITHUB_TOKEN="${GITHUB_TOKEN}"  # Ensure this environment variable is set

# Fetch the run details
RUN_DETAILS=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/repos/${REPO}/actions/runs/${RUN_ID}")

# Extract the build version or artifact URL
# Assuming the version is available in the run details or artifacts
# You might need to adjust this depending on where the version is located
VERSION=$(echo "$RUN_DETAILS" | jq -r ".head_commit.message" | grep -oP "Version: \K[^\s]+")

# Alternatively, if the version is in an artifact, you may need to download and extract it
# Example:
# ARTIFACT_URL=$(echo "$RUN_DETAILS" | jq -r ".artifacts[0].archive_download_url")
# curl -L -H "Authorization: token ${GITHUB_TOKEN}" "$ARTIFACT_URL" -o artifact.zip
# unzip artifact.zip

echo "VERSION=${VERSION}" >> $GITHUB_ENV

# Fetch the latest version from the repository (if needed)
RELEASE="$(git ls-remote --sort='v:refname' --tags https://github.com/${REPO}.git | cut -d/ -f3- | tail -n1)"

echo "RELEASE=${RELEASE}" >> $GITHUB_ENV

if [ "${CURRENT}" != "${VERSION}" ]; then
    jq ".version=\"${VERSION}\"" $FILE > $FILE.tmp
    mv $FILE.tmp $FILE
fi
