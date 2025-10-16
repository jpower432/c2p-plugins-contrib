#!/bin/bash

# regenerate-manifests.sh
# This script regenerates plugin manifests for the Go Releaser pipeline

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Output directory for generated manifests
MANIFEST_DIR="$PROJECT_ROOT/c2p-plugins"

echo -e "${GREEN}Regenerating plugin manifests...${NC}"

# Create output directory if it doesn't exist
mkdir -p "$MANIFEST_DIR"

# Function to process a plugin manifest
process_plugin_manifest() {
    local plugin_dir="$1"
    local plugin_name="$(basename "$plugin_dir")"
    local manifest_file="$plugin_dir/plugin-manifest.json"
    local output_file="$MANIFEST_DIR/c2p-${plugin_name}-manifest.json"
    
    echo -e "${YELLOW}Processing $plugin_name...${NC}"
    
    # Check if manifest file exists
    if [[ ! -f "$manifest_file" ]]; then
        echo -e "${RED}Error: Manifest file not found: $manifest_file${NC}"
        return 1
    fi

    # Copy and update version from git tag if available
    cp "$manifest_file" "$output_file"
    
    # Try to get version from git tag
    if git describe --tags --exact-match HEAD >/dev/null 2>&1; then
        local git_version="$(git describe --tags --exact-match HEAD | sed 's/^v//')"
        echo -e "${YELLOW}Updating version to $git_version from git tag${NC}"
        
        # Update version in the copied manifest
        jq --arg version "$git_version" '.version = $version' "$output_file" > "$output_file.tmp" && mv "$output_file.tmp" "$output_file"
    else
        # Try to get version from go.mod or use default
        local go_version="$(cd "$plugin_dir" && go list -m -f '{{.Version}}' . 2>/dev/null || echo "0.0.0")"
        if [[ "$go_version" != "0.0.0" ]]; then
            echo -e "${YELLOW}Updating version to $go_version from go.mod${NC}"
            jq --arg version "$go_version" '.version = $version' "$output_file" > "$output_file.tmp" && mv "$output_file.tmp" "$output_file"
        fi
    fi
    
    # Add build metadata
    local build_time="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    local git_commit="$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")"
    
    # Add build information to metadata
    jq --arg build_time "$build_time" --arg git_commit "$git_commit" \
       '.metadata.build_time = $build_time | .metadata.git_commit = $git_commit' \
       "$output_file" > "$output_file.tmp" && mv "$output_file.tmp" "$output_file"
    
    # Calculate SHA256 checksum of the built plugin binary and copy it to c2p-plugins
    local binary_path="$PROJECT_ROOT/c2p-plugins/$plugin_name"
    local output_binary="$MANIFEST_DIR/$plugin_name"
    
    if [[ -f "$binary_path" ]]; then
        # Copy binary to c2p-plugins directory
        cp "$binary_path" "$output_binary"
        echo -e "${YELLOW}Copied binary: $binary_path -> $output_binary${NC}"
        
        # Calculate checksum of the copied binary
        local checksum="$(sha256sum "$output_binary" | cut -d' ' -f1)"
        echo -e "${YELLOW}Calculated checksum for $plugin_name: $checksum${NC}"
        
        # Update checksum in the manifest
        jq --arg checksum "$checksum" '.sha256 = $checksum' \
           "$output_file" > "$output_file.tmp" && mv "$output_file.tmp" "$output_file"
    else
        echo -e "${RED}Warning: Binary not found at $binary_path, leaving checksum empty${NC}"
    fi
    
    echo -e "${GREEN}Generated: $output_file${NC}"
}

# Find all plugin directories
plugin_dirs=()
for dir in "$PROJECT_ROOT"/*-plugin; do
    if [[ -d "$dir" && -f "$dir/plugin-manifest.json" ]]; then
        plugin_dirs+=("$dir")
    fi
done

if [[ ${#plugin_dirs[@]} -eq 0 ]]; then
    echo -e "${RED}Error: No plugin directories with manifest files found${NC}"
    exit 1
fi

echo -e "${GREEN}Found ${#plugin_dirs[@]} plugin(s) to process${NC}"

# Process each plugin
for plugin_dir in "${plugin_dirs[@]}"; do
    if ! process_plugin_manifest "$plugin_dir"; then
        echo -e "${RED}Failed to process plugin: $plugin_dir${NC}"
        exit 1
    fi
done

echo -e "${GREEN}All plugin manifests regenerated successfully!${NC}"
echo -e "${GREEN}Manifest files are available in: $MANIFEST_DIR${NC}"

# List generated files
echo -e "${YELLOW}Generated files:${NC}"
echo -e "${YELLOW}Manifest files:${NC}"
ls -la "$MANIFEST_DIR"/*.json 2>/dev/null || echo "No manifest files found"
echo -e "${YELLOW}Binary files:${NC}"
ls -la "$MANIFEST_DIR"/*-plugin 2>/dev/null || echo "No binary files found"