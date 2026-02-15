#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_FILE="fixtures/paletter.rb"
OUTPUT_FILE="paletter.rb"
REPO="-R ceejbot/paletter"

TAG_NAME="${1:?Usage: formula.sh <tag>}"
VERSION="${TAG_NAME#v}"

# paletter-universal-apple-darwin.tar.gz
UNIV_URL=$(gh release view "$TAG_NAME" $REPO --json assets --jq '.assets[] | select(.name | contains("universal")) | .url' | head -1)

if [[ -z "$UNIV_URL" ]]; then
    echo "ERROR: Could not find universal binary asset in release $TAG_NAME" >&2
    exit 1
fi

# Compute SHA256 from the actual tarball, not the GitHub API digest field
UNIV_SHA256=$(curl -sL "$UNIV_URL" | shasum -a 256 | awk '{print $1}')

sed -e "s|{{ VERSION }}|$VERSION|g" \
    -e "s|{{ UNIV_URL }}|$UNIV_URL|g" \
    -e "s|{{ UNIV_SHA256 }}|$UNIV_SHA256|g" \
    "$TEMPLATE_FILE" > "$OUTPUT_FILE"

echo "Generated $OUTPUT_FILE (version $VERSION)"
