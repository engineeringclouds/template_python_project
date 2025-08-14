# template_python_project

[![CI](https://github.com/engineeringclouds/template_python_project/actions/workflows/ci.yml/badge.svg)](https://github.com/engineeringclouds/template_python_project/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python 3.13+](https://img.shields.io/badge/python-3.13%2B-blue.svg)](https://www.python.org/downloads/)
[![pre-commit enabled](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://pre-commit.com/)
[![Docker Ready](https://img.shields.io/badge/docker-ready-blue?logo=docker)](https://hub.docker.com/)

A minimal, secure, and modern Python project template with a basic Hello World app, containerization support, and robust development tooling.

## Features

-   Python 3.13+ compatible
-   Minimal Hello World application
-   Containerization with Docker
-   Pre-commit hooks and code style enforcement (Black, Ruff, Mypy)
-   Bootstrap scripts for easy setup (Linux/macOS and Windows)
-   Security best practices (see below)
-   Well-documented and easy to use

## Security Best Practices

-   Uses virtual environments for dependency isolation
-   No secrets or sensitive data in code or config
-   `.gitignore` excludes common sensitive files and folders
-   Container runs as non-root by default (see Dockerfile for customization)
-   Dependencies managed via `pyproject.toml` for reproducibility
-   Pre-commit hooks help catch common mistakes before code is committed

## Getting Started

### Local Development

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/template_python_project.git
    cd template_python_project
    ```
2. Run the bootstrap script for your OS:
    - Linux/macOS:
        ```sh
        ./scripts/bootstrap.sh
        ```
    - Windows (PowerShell):
        ```powershell
        .\scripts\bootstrap.ps1
        ```
3. Run the app:
    ```sh
    python -m template_python_project
    ```

### Running in a Container

1. Build the Docker image:
    ```sh
    docker build -t template-python-project .
    ```
2. Run the container:
    ```sh
    docker run --rm template-python-project
    ```

### Running Tests

```sh
pytest
```

## Documentation

-   See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
-   See [CHANGELOG.md](CHANGELOG.md) for release history
-   See [LICENSE](LICENSE) for license details

## Project URLs

-   [Homepage](https://github.com/yourusername/template_python_project)
-   [Documentation](https://yourusername.github.io/template_python_project/)
-   [Source](https://github.com/yourusername/template_python_project)
-   [Tracker](https://github.com/yourusername/template_python_project/issues)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the [MIT License](LICENSE).
