#!/bin/sh

# Ensure TOKEN_GITHUB is set
if [ -z "${TOKEN_GITHUB}" ]; then
    echo "Error: TOKEN_GITHUB is not set."
    exit 1
fi

# Verify token by checking user details
echo "Checking token validity..."
TOKEN_VALIDATION=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token ${TOKEN_GITHUB}" "https://api.github.com/user")

if [ "$TOKEN_VALIDATION" -ne 200 ]; then
    echo "Invalid token or authentication failed. HTTP status code: ${TOKEN_VALIDATION}"
    exit 1
fi

echo "Token is valid."

# Fetch GitHub Actions run details
REPO="hyperion-project/hyperion.ng"
RUN_ID="10539641052"
RUN_DETAILS=$(curl -s -H "Authorization: token ${TOKEN_GITHUB}" "https://api.github.com/repos/${REPO}/actions/runs/${RUN_ID}")

echo "Run details:"
echo "$RUN_DETAILS"

# Example of extracting artifact URL (ensure artifacts are present)
ARTIFACT_URL=$(echo "$RUN_DETAILS" | jq -r '.artifacts[0].archive_download_url')

echo "Artifact URL: ${ARTIFACT_URL}"

# Example of extracting version from commit message
VERSION=$(echo "$RUN_DETAILS" | jq -r ".head_commit.message" | grep -oP "Version: \K[^\s]+")

echo "VERSION=${VERSION}"
