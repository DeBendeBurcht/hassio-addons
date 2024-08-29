#!/bin/sh

BASE=${GITHUB_WORKSPACE}/addon-hyperion-ng
FILE="${BASE}/config.json"
CURRENT="$(jq -r ".version" $FILE)"

# Define the GitHub repository and the specific run ID
REPO="hyperion-project/hyperion.ng"
RUN_ID="10539641052"  # The specific run ID from the URL

# Get the GitHub token from environment variable
TOKEN_GITHUB="${TOKEN_GITHUB}"  # Ensure this environment variable is set correctly

# Check if the token is valid by making a request to the GitHub API
TOKEN_VALIDATION=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token ${TOKEN_GITHUB}" "https://api.github.com/user")

if [ "$TOKEN_VALIDATION" -ne 200 ]; then
    echo "Invalid token or authentication failed. HTTP status code: ${TOKEN_VALIDATION}"
    exit 1
fi

echo "Token is valid."

# Fetch the run details
RUN_DETAILS=$(curl -s -H "Authorization: token ${TOKEN_GITHUB}" "https://api.github.com/repos/${REPO}/actions/runs/${RUN_ID}")

# Print the full run details for debugging
echo "Run details:"
echo "$RUN_DETAILS"

# Extract the artifact URL (ensure artifacts are present)
ARTIFACT_URL=$(echo "$RUN_DETAILS" | jq -r '.artifacts[0].archive_download_url')

# Print the artifact URL
echo "Artifact URL: ${ARTIFACT_URL}"

# Extract the version from the commit message or other relevant fields
VERSION=$(echo "$RUN_DETAILS" | jq -r ".head_commit.message" | grep -oP "Version: \K[^\s]+")

# Print the version
echo "VERSION=${VERSION}"

# Fetch the latest version from the repository (if needed)
RELEASE="$(git ls-remote --sort='v:refname' --tags https://github.com/${REPO}.git | cut -d/ -f3- | tail -n1)"

# Print the latest release
echo "RELEASE=${RELEASE}"

# Update the config file if necessary
if [ "${CURRENT}" != "${VERSION}" ]; then
    jq ".version=\"${VERSION}\"" $FILE > $FILE.tmp
    mv $FILE.tmp $FILE
fi
