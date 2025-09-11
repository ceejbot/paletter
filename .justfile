BINNAME := "paletter"
RELATIVE_TAP_PATH := "../../../homebrew-tap/"

_help:
	just -l

# Build the project
build:
	swift build

# Run all tests using swift test.
test:
	swift test

# Run the same checks we run in CI.
ci: test

# Format Swift code using swift-format (if installed)
fmt:
	swift-format -i -r Sources/

# Lint Swift code using SwiftLint (if installed)
lint:
	swiftlint Sources

# Run the app with fixtures directory
run DIR="fixtures":
	swift run paletter {{DIR}}

# Clean build artifacts
clean:
	swift package clean

# Install required tools
setup:
	brew tap ceejbot/tap
	brew install fzf semver-bump swift-format swiftlint

# Build release binary (universal)
@release:
	#!/usr/bin/env bash
	echo "Building universal release binary..."
	swift build -c release --arch arm64
	swift build -c release --arch x86_64
	mkdir -p dist
	lipo -create \
		.build/arm64-apple-macosx/release/paletter \
		.build/x86_64-apple-macosx/release/paletter \
		-output dist/paletter
	chmod +x dist/paletter
	echo "Universal binary created at dist/paletter"

# Tag a new version for release
version BUMP:
	#!/usr/bin/env bash
	set -e
	# Read current version or default to 1.0.0
	if [ ! -f VERSION ]; then echo "1.0.0" > VERSION; fi
	current=$(cat VERSION)
	version=$(semver-bump {{BUMP}} "$current")

	# Update Version.swift file
	sed -i '' "s/static let current = \".*\"/static let current = \"$version\"/" Sources/Version.swift

	# Commit and tag
	git add VERSION Sources/Version.swift
	git commit -m "v${version}"
	git tag "v${version}"
	echo "Release tagged for version v${version}"
