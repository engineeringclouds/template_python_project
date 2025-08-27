# template_python_project

[![CI](https://github.com/engineeringclouds/template_python_project/actions/workflows/ci.yml/badge.svg)](https://github.com/engineeringclouds/template_python_project/actions/workflows/ci.yml)
[![Container Build](https://github.com/engineeringclouds/template_python_project/actions/workflows/container.yml/badge.svg)](https://github.com/engineeringclouds/template_python_project/actions/workflows/container.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python 3.13+](https://img.shields.io/badge/python-3.13%2B-blue.svg)](https://www.python.org/downloads/)
[![pre-commit enabled](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://pre-commit.com/)
[![Docker Ready](https://img.shields.io/badge/docker-ready-blue?logo=docker)](https://hub.docker.com/)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

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
    git clone https://github.com/engineeringclouds/template_python_project.git
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

## Example Output

When you run the application, you should see:

```sh
$ python -m template_python_project
Hello, world!
```

## GitHub Repository Configuration

This template includes automated GitHub repository configuration to set up optimal open source project settings.

### Automated Setup

Run the configuration script to automatically configure your repository:

```sh
# Make the script executable
chmod +x scripts/configure-github-repo.sh

# Configure your repository
./scripts/configure-github-repo.sh

# Or configure a different repository
./scripts/configure-github-repo.sh your-username/your-repo
```

### What Gets Configured

-   **Repository Settings**: Description, topics, discussions, wiki, template status
-   **Labels**: Comprehensive label system for issues and PRs
-   **Branch Protection**: Protects main branch with required status checks
-   **Community Health**: Verifies presence of all community health files

### Prerequisites

1. Install [GitHub CLI](https://cli.github.com/): `brew install gh` (macOS) or see [installation guide](docs/github-cli-reference.md)
2. Authenticate: `gh auth login`

For detailed information, see:

-   [GitHub Configuration Guide](docs/github-configuration.md)
-   [GitHub CLI Reference](docs/github-cli-reference.md)

## Troubleshooting

### Test Import Issues

If you encounter import errors when running tests, ensure you're using pytest with the correct configuration. The `pyproject.toml` includes `pythonpath = ["src"]` which should resolve import issues automatically.

If problems persist, you can run tests with:

```sh
PYTHONPATH=src pytest
```

### Virtual Environment Issues

If the bootstrap scripts fail, ensure Python 3.13+ is installed and accessible. You can check with:

```sh
python --version  # or python3 --version on some systems
```

### Security Note

For production use, remember to:

-   Remove placeholder files like `.venv/.gitkeep`
-   Update URLs in `pyproject.toml` to match your project
-   Review and update the security practices for your specific use case
-   Consider using `pip-audit` to check for known security vulnerabilities:
    ```sh
    pip install pip-audit
    pip-audit
    ```

## CI/CD Pipeline

This project uses GitHub Actions with a robust CI/CD pipeline:

### Workflow Dependencies

```
Push/PR → CI Workflow (Lint + Format + Type Check + Test)
            ↓ (on success)
          Container Workflow (Build + Test + Security Scan)

Push to main → Release Workflow (Semantic Versioning + Template Validation)
```

1. **CI Workflow** (`ci.yml`): Runs on every push and pull request

    - Linting with Ruff
    - Code formatting check with Black
    - Type checking with MyPy
    - Testing with pytest
    - Cross-platform testing (Ubuntu, Windows, macOS)

2. **Container Workflow** (`container.yml`): Only runs after CI passes
    - **Dependency**: Waits for CI workflow to complete successfully
    - Docker image building and testing
    - Container security scanning with Trivy
    - SARIF upload for security findings

3. **Release Workflow** (`release.yml`): Automated semantic versioning
    - **Dependency**: Runs on pushes to main branch
    - Analyzes conventional commits for version bumps
    - Generates changelogs and creates GitHub releases
    - Validates template functionality by building packages
    - Supports manual releases with custom options

This ensures that only validated, tested code gets containerized and released, following the fail-fast principle and optimizing resource usage.

### Automated Template Releases

The project uses [semantic versioning](https://semver.org/) with [conventional commits](https://www.conventionalcommits.org/) to manage template releases:

- `feat:` → Minor version bump (0.1.0 → 0.2.0) - New template features
- `fix:` → Patch version bump (0.1.0 → 0.1.1) - Template fixes  
- `feat!:` or `BREAKING CHANGE:` → Major version bump (0.1.0 → 1.0.0) - Breaking changes

Each release validates that the template produces working Python projects and provides clear upgrade paths for existing users.

See [Release Workflow Guide](docs/release-workflow.md) for detailed information.

## Documentation

-   See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
-   See [Release Workflow Guide](docs/release-workflow.md) for automated release information
-   See [GitHub Configuration Guide](docs/github-configuration.md) for repository setup
-   See [GitHub CLI Reference](docs/github-cli-reference.md) for CLI automation
-   See [CHANGELOG.md](CHANGELOG.md) for release history
-   See [LICENSE](LICENSE) for license details

## Project URLs

-   [Homepage](https://github.com/engineeringclouds/template_python_project)
-   [Documentation](https://engineeringclouds.github.io/template_python_project/)
-   [Source](https://github.com/engineeringclouds/template_python_project)
-   [Tracker](https://github.com/engineeringclouds/template_python_project/issues)

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## License

This project is licensed under the [MIT License](LICENSE).
