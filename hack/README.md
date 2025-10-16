# Plugin Manifest System

This directory contains tools and scripts for managing C2P plugin manifests.

## Overview

Each plugin in this repository should have a `plugin-manifest.json` file in its root directory. This manifest describes the plugin's capabilities, endpoints, dependencies, and configuration options.

## Files

- `regenerate-manifests.sh` - Script to regenerate manifests for the Go Releaser pipeline

## Plugin Manifest Structure

A plugin manifest should include:

- **Basic Information**: name, version, description, author, license
- **Plugin Type**: policy-engine, compliance-scanner, remediation, reporting
- **Capabilities**: List of what the plugin can do
- **Endpoints**: API endpoints the plugin exposes
- **Dependencies**: Runtime and build dependencies
- **Configuration**: Environment variables and config files
- **Metadata**: Repository, documentation, keywords, tags

## Usage

### Adding a New Plugin

1. Create a new plugin directory (e.g., `my-plugin/`)
2. Add a `plugin-manifest.json` file
3. The manifest will be automatically included in releases

### Regenerating Manifests

The `regenerate-manifests.sh` script:

1. Finds all plugin directories with manifest files
2. Updates version information from git tags or go.mod
3. Adds build metadata (timestamp, git commit)
4. Generates final manifests in `c2p-plugins/` directory

Run it manually:
```bash
./hack/regenerate-manifests.sh
```

Or use the Makefile:
```bash
make regenerate-manifests
```

## Integration with Go Releaser

The Go Releaser pipeline automatically:

1. Runs `make build-plugins` to build all plugins
2. Runs `./hack/regenerate-manifests.sh` to generate manifests
3. Includes the generated manifests in release archives

## Requirements

- `jq` - For JSON processing
- `git` - For version information
- `go` - For Go module version detection

## Example Manifest

See `kyverno-plugin/plugin-manifest.json` or `ocm-plugin/plugin-manifest.json` for examples.