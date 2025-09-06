# Supply Chain Security and SBOM Documentation

## Overview

This template implements comprehensive supply chain security practices, including automated Software Bill of Materials (SBOM) generation, to ensure transparency and security throughout the software development lifecycle.

## What is an SBOM?

A Software Bill of Materials (SBOM) is a formal, machine-readable inventory of software components and dependencies used in building software. It provides transparency into the software supply chain, similar to how ingredient lists work for food products.

## Why SBOMs Matter

### 🔒 **Security Benefits**

-   **Vulnerability Identification**: Quickly identify if your software contains vulnerable components
-   **Incident Response**: Rapidly assess impact when new vulnerabilities are discovered
-   **Supply Chain Attacks**: Detect compromised dependencies or malicious packages

### 📋 **Compliance & Governance**

-   **Regulatory Requirements**: Meet increasing compliance requirements (NIST, CISA guidelines)
-   **Enterprise Policies**: Satisfy organizational security and procurement policies
-   **Audit Trails**: Provide complete documentation for security audits

### 🔍 **Operational Benefits**

-   **License Compliance**: Track software licenses and ensure compliance
-   **Dependency Management**: Better understand and manage your dependency tree
-   **Risk Assessment**: Evaluate the security posture of your software stack

## SBOM Generation Process

### Automated Generation

SBOMs are automatically generated during the release process in multiple formats:

1. **SPDX JSON** (`sbom.spdx.json`)

    - Industry-standard format
    - Broad tool compatibility
    - Legal and compliance focus

2. **CycloneDX JSON** (`sbom.cyclonedx.json`)

    - Security-focused format
    - Rich vulnerability data support
    - Modern tooling ecosystem

3. **CycloneDX XML** (`sbom.cyclonedx.xml`)
    - XML variant of CycloneDX
    - Enterprise system integration
    - Legacy tool compatibility

### Generation Tools

-   **Anchore SBOM Action**: Generates SPDX format SBOMs
-   **CycloneDX Python**: Creates CycloneDX format SBOMs from Python requirements

## Using SBOMs

### Access and Download

SBOMs are made available in multiple ways:

#### **GitHub Releases (Permanent)**

SBOMs are permanently attached to every GitHub release as downloadable assets:

```bash
# Download SBOM files from latest release
gh release download --pattern "sbom.*"

# Download specific format
gh release download --pattern "sbom.spdx.json"

# Direct download with curl (replace v1.0.0 with actual version)
curl -L -O https://github.com/owner/repo/releases/download/v1.0.0/sbom.spdx.json
```

#### **GitHub Actions Artifacts (90 days)**

For workflow validation and debugging, SBOMs are also stored as artifacts:

```bash
# Access via GitHub CLI
gh run download [run-id] --name sbom-artifacts

# Or download from the GitHub Actions UI
# Navigate to: Actions → Release workflow → Artifacts section
```

### Vulnerability Analysis

Use SBOMs with security scanning tools:

```bash
# Install analysis tools
pip install cyclonedx-python-lib safety

# Vulnerability scanning with grype
grype sbom:sbom.spdx.json

# OSV vulnerability scanning
osv-scanner --sbom sbom.cyclonedx.json

# Safety check (requires requirements format)
safety check --json --output sbom-vulns.json
```

### Enterprise Integration

SBOMs can be ingested into enterprise security platforms:

#### **Dependency-Track Integration**

```bash
# Upload SBOM to Dependency-Track
curl -X "POST" "http://dependency-track/api/v1/bom" \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d @sbom.cyclonedx.json
```

#### **Other Platform Support**

-   **JFrog Xray**: Import SBOMs for vulnerability scanning and license compliance
-   **Snyk**: Upload for developer-first security workflows
-   **GitHub Advanced Security**: Native integration with code scanning
-   **Azure DevOps**: Import via REST API for enterprise compliance
-   **Jenkins**: Plugin-based SBOM analysis in CI/CD pipelines

#### **Compliance and Auditing**

```bash
# License compliance analysis
python -c "
import json
with open('sbom.spdx.json') as f:
    sbom = json.load(f)
    for package in sbom.get('packages', []):
        name = package.get('name', 'Unknown')
        license = package.get('licenseConcluded', 'Unknown')
        print(f'{name}: {license}')
"

# Component inventory for audits
jq '.components[] | {name: .name, version: .version, type: .type}' sbom.cyclonedx.json
```

## Implementation Details

### Release Workflow Integration

The SBOM generation is integrated into the release workflow:

```yaml
- name: Security | Generate SBOM
  uses: anchore/sbom-action@v0
  with:
      path: ./
      format: spdx-json
      output-file: "sbom.spdx.json"

- name: Security | Generate SBOM (CycloneDX format)
  run: |
      pip install cyclonedx-bom
      cyclonedx-py requirements -o sbom.cyclonedx.json --format json
      cyclonedx-py requirements -o sbom.cyclonedx.xml --format xml
```

### Dependency Management

Dependencies are managed through `pyproject.toml`:

```toml
[project.optional-dependencies]
dev = [
    # ... other dependencies
    "cyclonedx-bom",  # SBOM generation
]
```

### Storage and Distribution

-   **GitHub Artifacts**: 90-day retention for security tracking
-   **Release Assets**: Permanently attached to releases
-   **Multiple Formats**: Support different tool ecosystems

## Best Practices

### For Template Users

1. **Review SBOMs**: Regularly review generated SBOMs for new dependencies
2. **Automate Scanning**: Integrate SBOM analysis into your security workflows
3. **Monitor Vulnerabilities**: Set up alerts for new vulnerabilities in your dependencies
4. **Update Dependencies**: Keep dependencies current to minimize security exposure

### For Organizations

1. **Policy Integration**: Include SBOM requirements in software procurement policies
2. **Centralized Analysis**: Use platforms like Dependency-Track for centralized SBOM analysis
3. **Compliance Tracking**: Maintain SBOMs for compliance and audit purposes
4. **Incident Response**: Use SBOMs for rapid impact assessment during security incidents

## Security Scanning Integration

This template combines SBOM generation with active vulnerability scanning:

### PR Validation

-   **Trivy Container Scanning**: Scans container images for vulnerabilities
-   **Dependency Analysis**: Reviews new dependencies in pull requests

### Release Security

-   **SBOM Generation**: Complete dependency inventory
-   **Vulnerability Baseline**: Establishes security baseline for releases

### Continuous Monitoring

-   **Dependabot**: Automated dependency updates
-   **Security Advisories**: GitHub security advisory monitoring

## Compliance Frameworks

This SBOM implementation supports various compliance frameworks:

### NIST Guidelines

-   **NIST SP 800-218**: Secure Software Development Framework (SSDF)
-   **NIST Cybersecurity Framework**: Supply chain risk management

### CISA Requirements

-   **CISA SBOM Guidance**: Federal software procurement requirements
-   **Critical Software Definition**: Enhanced security for critical software

### Industry Standards

-   **SPDX**: Software Package Data Exchange standard
-   **CycloneDX**: OWASP software supply chain standard
-   **ISO/IEC 5962**: SPDX specification standard

## Troubleshooting

### Common Issues

**SBOM Generation Fails**

```bash
# Check dependencies are properly declared
pip list --format=freeze > requirements.txt
cyclonedx-py requirements -i requirements.txt

# Verify tool installation
pip install cyclonedx-bom --upgrade
```

**Missing Dependencies in SBOM**

-   Ensure all dependencies are declared in `pyproject.toml`
-   Check that virtual environment includes all packages
-   Verify tool can access all dependency metadata

**Format Compatibility Issues**

-   Use SPDX for broad compatibility
-   Use CycloneDX for security-focused tools
-   Convert between formats using available tools

### Getting Help

For SBOM-related issues:

1. Check the [SPDX documentation](https://spdx.dev/)
2. Review [CycloneDX guides](https://cyclonedx.org/)
3. Consult tool-specific documentation
4. Open an issue in this repository for template-specific problems

## Future Enhancements

Planned improvements to SBOM generation:

-   **Container SBOM**: Generate SBOMs for container images
-   **Build-time SBOMs**: Capture build environment dependencies
-   **Signed SBOMs**: Cryptographic signatures for SBOM integrity
-   **SBOM Diffing**: Compare SBOMs between releases
-   **Integration APIs**: Webhook integration for security platforms

## References

-   [NIST SBOM Guide](https://www.nist.gov/itl/executive-order-improving-nations-cybersecurity/software-bill-materials)
-   [CISA SBOM Guidance](https://www.cisa.gov/sbom)
-   [SPDX Specification](https://spdx.github.io/spdx-spec/)
-   [CycloneDX Specification](https://cyclonedx.org/specification/overview/)
-   [OWASP Dependency Track](https://dependencytrack.org/)
