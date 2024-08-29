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

# Extract the artifact URL
# If you need a specific artifact, you might need additional filtering
ARTIFACT_URL=$(echo "$RUN_DETAILS" | jq -r '.artifacts[0].archive_download_url')

# Print the artifact URL
echo "Artifact URL: ${ARTIFACT_URL}"

# Extract the version from the commit message or other relevant fields
VERSION=$(echo "$RUN_DETAILS" | jq -r ".head_commit.message" | grep -oP "Version: \K[^\s]+")

# Print the version
echo "VERSION=${VERSION}"

# Fetch the latest version from the repository (if needed)
RELEASE="$(git ls-remote --sort='v:refname' --tags https://github.com/${REPO}.git | cut -d/ -f3- | tail -n1)"

echo "RELEASE=${RELEASE}" >> $GITHUB_ENV

if [ "${CURRENT}" != "${VERSION}" ]; then
    jq ".version=\"${VERSION}\"" $FILE > $FILE.tmp
    mv $FILE.tmp $FILE
fi
