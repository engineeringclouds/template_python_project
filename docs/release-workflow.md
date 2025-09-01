# Release Workflow Guide

This project uses automated semantic versioning and release management powered by [python-semantic-release](https://python-semantic-release.readthedocs.io/) and GitHub Actions to manage template releases.

## Overview

The release workflow automatically:

1. **Analyzes commit messages** to determine version bump (major/minor/patch)
2. **Updates version numbers** in template code
3. **Generates changelogs** based on conventional commits
4. **Creates GitHub releases** with release notes and template artifacts
5. **Validates template functionality** by building example packages
6. **Tags releases** and pushes changes back to the repository

## Template Release Process

Unlike a typical Python package, this template repository focuses on:

-   **Template Validation**: Ensures the template produces valid Python packages
-   **Documentation Updates**: Keeps setup guides and examples current
-   **Feature Tracking**: Chronicles improvements to the template structure
-   **User Experience**: Provides clear release notes for template users

## Conventional Commits

The release system uses [Conventional Commits](https://www.conventionalcommits.org/) to automatically determine version bumps:

### Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types and Version Bumps

| Type                          | Description              | Version Bump              | Template Impact                               |
| ----------------------------- | ------------------------ | ------------------------- | --------------------------------------------- |
| `feat`                        | New template feature     | **Minor** (0.1.0 → 0.2.0) | New functionality, tools, or capabilities     |
| `fix`                         | Template bug fix         | **Patch** (0.1.0 → 0.1.1) | Fixes to workflows, configs, or documentation |
| `perf`                        | Performance improvement  | **Patch** (0.1.0 → 0.1.1) | Faster builds, optimized workflows            |
| `feat!` or `BREAKING CHANGE:` | Breaking template change | **Major** (0.1.0 → 1.0.0) | Structural changes, new requirements          |

### Other Types (No Version Bump)

-   `docs`: Documentation changes
-   `style`: Code style changes (formatting, etc.)
-   `refactor`: Code refactoring
-   `test`: Adding or updating tests
-   `chore`: Build tasks, dependencies, etc.
-   `ci`: CI/CD changes

### Examples

```bash
# Patch release (0.1.0 → 0.1.1) - Template fixes
git commit -m "fix: resolve GitHub Actions workflow syntax error"

# Minor release (0.1.0 → 0.2.0) - New template features
git commit -m "feat: add automated security scanning to CI pipeline"

# Major release (0.1.0 → 1.0.0) - Breaking template changes
git commit -m "feat!: migrate to Python 3.13 and update all dependencies

BREAKING CHANGE: Minimum Python version is now 3.13"

# No release - Template maintenance
git commit -m "docs: update README with new setup instructions"
```

## Triggering Releases

### Automatic Releases

-   **Push to `main`**: Automatically analyzes commits and creates releases
-   Runs after successful CI checks
-   Only releases if there are releasable commits since last release

### Manual Releases

Use GitHub's workflow dispatch to manually trigger releases:

1. Go to **Actions** → **Release** workflow
2. Click **Run workflow**
3. Choose options:
    - **Force Level**: Override automatic version detection
    - **Prerelease**: Create a prerelease (e.g., `1.0.0-rc.1`)
    - **Dry Run**: Test the release process without making changes

## Release Workflow Steps

### 1. Quality Checks

-   Run full test suite with coverage
-   Lint code with Ruff
-   Check type annotations with MyPy
-   Verify code formatting with Black

### 2. Version Analysis

-   Analyze commit messages since last release
-   Determine appropriate version bump
-   Generate release notes and changelog

### 3. Release Creation

-   Update version in `src/template_python_project/__init__.py`
-   Generate/update `CHANGELOG.md`
-   Create Git tag
-   Create GitHub release with notes

### 4. Template Validation

-   Build Python packages to verify template structure
-   Validate package metadata with twine
-   Upload sample distributions to GitHub release assets
-   Test template functionality

## Configuration

### Semantic Release Settings

Configuration is in `pyproject.toml`:

```toml
[tool.semantic_release]
version_variables = [
    "src/template_python_project/__init__.py:__version__",
]
build_command = "python -m pip install build && python -m build"
dist_path = "dist/"
upload_to_vcs_release = true

[tool.semantic_release.commit_parser_options]
allowed_tags = ["build", "chore", "ci", "docs", "feat", "fix", "perf", "style", "refactor", "test"]
minor_tags = ["feat"]
patch_tags = ["fix", "perf"]
```

### PyPI Publishing

This template repository does not publish to PyPI since it's designed to be used as a GitHub template. However, the release workflow validates that projects created from this template can successfully build and publish Python packages.

To enable PyPI publishing in projects created from this template:

1. **Configure PyPI credentials** in your new repository
2. **Update package name** in `pyproject.toml`
3. **Add PyPI deployment jobs** to the release workflow

#### Example PyPI Deployment Job

Add this job to your `.github/workflows/release.yml` file:

```yaml
pypi-publish:
    name: Publish to PyPI
    runs-on: ubuntu-latest
    needs: release
    if: needs.release.outputs.released == 'true' && github.event.inputs.dry_run != 'true'

    permissions:
        id-token: write # For trusted publishing
        contents: read

    environment:
        name: pypi
        url: https://pypi.org/p/${{ github.repository_owner }}-${{ github.event.repository.name }}

    steps:
        - name: Download Distribution Artifacts
          uses: actions/download-artifact@v4
          with:
              name: python-distribution-artifacts
              path: dist/

        - name: Publish to PyPI
          uses: pypa/gh-action-pypi-publish@release/v1
          with:
              print-hash: true
              verbose: true
```

#### PyPI Configuration Requirements

1. **Trusted Publisher Setup** (Recommended):

    - Go to PyPI → Account Settings → Publishing
    - Add GitHub as a trusted publisher for your repository
    - Specify workflow: `release.yml` and environment: `pypi`

2. **Alternative: API Token Setup**:

    ```yaml
    # Add this to the publish step if not using trusted publishing
    - name: Publish to PyPI
      uses: pypa/gh-action-pypi-publish@release/v1
      with:
          password: ${{ secrets.PYPI_API_TOKEN }}
    ```

3. **Repository Settings**:
    - Create a `pypi` environment in GitHub repository settings
    - Add protection rules if desired (e.g., require reviewers)

## Troubleshooting

### No Release Created

-   Check commit messages follow conventional format
-   Ensure commits since last release are releasable types
-   Verify CI checks pass

### Version Not Updated

-   Check `version_variables` configuration in `pyproject.toml`
-   Ensure `__version__` exists in `src/template_python_project/__init__.py`

### PyPI Upload Fails

-   Verify PyPI API token configuration
-   Check package name availability
-   Ensure trusted publisher configuration (recommended)

### Manual Release Recovery

If automatic release fails, you can recover:

```bash
# Check what version would be released
semantic-release version --noop

# Force a specific version
semantic-release version --patch  # or --minor, --major

# Skip certain steps
semantic-release version --no-commit --no-tag --no-push
```

## Best Practices

1. **Use conventional commits** consistently
2. **Write descriptive commit messages** for better changelogs
3. **Test locally** before pushing to main
4. **Use dry run** to test release process
5. **Keep breaking changes minimal** and well-documented
6. **Review generated changelogs** and release notes

## Example Workflow

```bash
# 1. Create feature branch
git checkout -b feat/user-authentication

# 2. Make changes and commit with conventional format
git commit -m "feat: add JWT authentication system"
git commit -m "test: add authentication unit tests"
git commit -m "docs: update API documentation for auth endpoints"

# 3. Push and create PR
git push origin feat/user-authentication

# 4. Merge to main (triggers automatic release)
# → CI runs → Release workflow → New minor version released
```

## Related Documentation

-   [Conventional Commits Specification](https://www.conventionalcommits.org/)
-   [Python Semantic Release Documentation](https://python-semantic-release.readthedocs.io/)
-   [GitHub Actions Documentation](https://docs.github.com/en/actions)
-   [PyPI Publishing Guide](https://packaging.python.org/en/latest/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/)
