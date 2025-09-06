# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in this template repository, please report it by:

1. **Do NOT** open a public issue
2. Send an email to security@engineeringclouds.com with details
3. Include steps to reproduce the vulnerability
4. Provide any relevant code or configuration

We will respond to security reports within 48 hours and work to address any confirmed vulnerabilities promptly.

## Security Best Practices

This template includes several security measures:

-   No hardcoded secrets or credentials
-   Secure Docker configuration with non-root user
-   Dependencies managed via `pyproject.toml` for reproducibility
-   `.gitignore` prevents accidental commit of sensitive files
-   Pre-commit hooks help catch security issues early

## Regular Security Maintenance

For projects based on this template, we recommend:

1. **Regular dependency updates**: Use tools like `pip-audit` or `safety`
2. **Security scanning**: Integrate security scanning into your CI/CD pipeline
3. **Code review**: Require code reviews for all changes
4. **Access control**: Use proper access controls and authentication
5. **Environment separation**: Keep development, staging, and production environments separate

## Dependencies Security

To check for known security vulnerabilities in dependencies:

```bash
pip install pip-audit
pip-audit
```

Consider automating this check in your CI/CD pipeline.

## Software Bill of Materials (SBOM)

This template automatically generates Software Bills of Materials (SBOMs) during releases to provide:

-   **Supply Chain Transparency**: Complete inventory of all dependencies
-   **Vulnerability Tracking**: Better identification of vulnerable components
-   **Compliance Support**: Meeting regulatory and organizational requirements

### SBOM Formats Generated

1. **SPDX JSON** (`sbom.spdx.json`) - Industry standard format
2. **CycloneDX JSON** (`sbom.cyclonedx.json`) - Security-focused format
3. **CycloneDX XML** (`sbom.cyclonedx.xml`) - Alternative CycloneDX format

### Using SBOMs

Download SBOMs from GitHub releases and use them with security tools:

```bash
# Analyze SBOM with vulnerability scanners
pip install cyclonedx-python-lib
python -c "from cyclonedx.model import Bom; print(Bom.from_json('sbom.cyclonedx.json'))"

# Use with dependency-track or other SBOM analysis tools
```
