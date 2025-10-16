# C2P Plugins Contrib

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Go Version](https://img.shields.io/badge/Go-1.24.7-blue.svg)](https://golang.org/)

Collection of community-contributed plugins for [Compliance-to-Policy (C2P)](https://github.com/oscal-compass/compliance-to-policy-go) framework.

## Contents

- Community-contributed plugins for various policy engines and compliance tools.
  - [Kyverno Plugin](./kyverno-plugin/): Plugin for integrating with Kyverno policy engine
  - [OCM Plugin](./ocm-plugin/): Plugin for Open Component Model (OCM) integration

## Project Status

This project contains community-contributed plugins for the Compliance-to-Policy framework. These plugins are maintained by the community and may have varying levels of stability and support.

## Getting Started

### Prerequisites

- Go 1.24.7 or later
- Access to the required policy engines or tools (e.g., Kyverno, OCM)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/oscal-compass/c2p-plugins-contrib.git
cd c2p-plugins-contrib
```

2. Build the plugins:
```bash
# Build all plugins
go build ./plugins/...

# Or build individual plugins
go build -o kyverno-plugin ./plugins/kyverno-plugin/
go build -o ocm-plugin ./plugins/ocm-plugin/
```

### Usage

Each plugin can be used as a standalone binary or integrated into the Compliance-to-Policy framework. Refer to individual plugin documentation for specific usage instructions.

#### Kyverno Plugin

The Kyverno plugin provides integration with the Kyverno policy engine for Kubernetes policy management.

```bash
./kyverno-plugin --help
```

#### OCM Plugin

The OCM plugin provides integration with the Open Component Model for component-based compliance management.

```bash
./ocm-plugin --help
```

## Plugin Development

### Creating a New Plugin

To create a new plugin for the C2P framework:

1. Create a new directory with your plugin name
2. Implement the required plugin interface from the C2P framework
3. Add a `main.go` file that registers your plugin
4. Include proper documentation and examples
5. Add tests for your plugin functionality

### Plugin Structure

Each plugin should follow this structure:

```
your-plugin/
├── main.go              # Plugin entry point
├── server/              # Plugin server implementation
│   ├── config.go        # Configuration handling
│   ├── server.go        # Main server logic
│   └── ...              # Additional server files
├── README.md            # Plugin-specific documentation
└── ...                  # Additional plugin files
```

Instructions for plugin building are [here](https://github.com/oscal-compass/compliance-to-policy-go/blob/main/plugin/README.md).

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

### Code Style

- Follow Go standard formatting (`gofmt`)
- Use meaningful variable and function names
- Add comments for exported functions and types
- Include tests for new functionality

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](./LICENSE) file for details.

## Support

- [OSCAL Compass Community](https://github.com/oscal-compass)
- [Compliance-to-Policy Framework](https://github.com/oscal-compass/compliance-to-policy-go)
- [Issues](https://github.com/oscal-compass/c2p-plugins-contrib/issues)

## Acknowledgments

- The OSCAL Compass community for the Compliance-to-Policy framework
- All contributors who have helped build and maintain these plugins
- The open-source community for the tools and libraries that make this project possible