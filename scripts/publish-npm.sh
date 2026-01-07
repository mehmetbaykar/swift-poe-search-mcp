#!/bin/bash
set -e

VERSION=${GITHUB_REF_NAME#v}

# Create platform directories
mkdir -p bin/linux-x64 bin/darwin-arm64

# Copy binaries from artifacts (runner.os = Linux, macOS)
cp artifacts/binary-Linux/swift-poe-search-mcp bin/linux-x64/
cp artifacts/binary-macOS/swift-poe-search-mcp bin/darwin-arm64/

# Make executable
chmod +x bin/*/swift-poe-search-mcp

# Show final sizes
echo "Final binary sizes:"
ls -lh bin/*/swift-poe-search-mcp

# Publish
npm version "$VERSION" --no-git-tag-version --allow-same-version
npm publish --provenance --access public
