#!/usr/bin/env bash
TEMPLATE_FILE="fixtures/paletter.rb"
OUTPUT_FILE="paletter.rb"
REPO="-R ceejbot/tomato"

TAG_NAME="$1"
VERSION="${TAG_NAME#v}"

# paletter-universal-apple-darwin.tar.gz
UNIV_URL=$(gh release view $REPO --json assets --jq '.assets[] | select(.name | contains("universal")) | .url ' | head -1)
UNIV_SHA256=$(gh release view $REPO --json assets --jq '.assets[] | select(.name | contains("universal")) | .digest ' | head -1)

UNIV_SHA256=${UNIV_SHA256#sha256:}

sed -e "s|{{ VERSION }}|$VERSION|g" \
    -e "s|{{ ARM64_URL }}|$UNIV_URL|g" \
    -e "s|{{ ARM64_SHA256 }}|$UNIV_SHA256|g" \
    "$TEMPLATE_FILE" > "$OUTPUT_FILE"
