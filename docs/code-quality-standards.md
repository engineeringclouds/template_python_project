# Code Quality and Standards Compliance Guide

This template adheres to Python Enhancement Proposals (PEPs) and modern Python best practices to ensure high code quality, maintainability, and compatibility.

## PEP 8 Compliance (Style Guide for Python Code)

### Automated Code Formatting and Linting

Our template uses a comprehensive toolchain to enforce PEP 8 compliance automatically:

#### Black - Code Formatter

**What it does:** Enforces consistent code formatting according to PEP 8
**Configuration:** `pyproject.toml`

```toml
[tool.black]
line-length = 88
target-version = ["py313"]
```

**Key PEP 8 elements handled:**

-   Line length (88 characters, slightly longer than PEP 8's 79 for readability)
-   Indentation (4 spaces)
-   Whitespace around operators
-   Function and class definitions spacing
-   Import formatting

#### Ruff - Fast Python Linter

**What it does:** Comprehensive linting covering PEP 8 and additional style rules
**Configuration:** `pyproject.toml`

```toml
[tool.ruff]
line-length = 88
target-version = "py313"
select = ["E", "F", "I"]  # E: pycodestyle errors, F: pyflakes, I: isort
```

**PEP 8 rules enforced:**

-   E: pycodestyle errors (PEP 8 violations)
-   F: pyflakes (undefined names, unused imports)
-   I: isort (import sorting per PEP 8)

### Manual PEP 8 Compliance Elements

Our codebase follows these PEP 8 principles:

#### Naming Conventions

-   **Functions and variables:** `snake_case`
-   **Constants:** `UPPER_SNAKE_CASE`
-   **Classes:** `PascalCase`
-   **Private attributes:** `_leading_underscore`
-   **Special methods:** `__double_underscore__`

#### Code Layout

-   **Indentation:** 4 spaces per level
-   **Maximum line length:** 88 characters
-   **Blank lines:** 2 lines around top-level classes/functions, 1 line around methods
-   **Imports:** Grouped in order (standard library, third-party, local)

#### Example of Compliant Code:

```python
"""Module docstring following PEP 257."""

import os
import sys

import requests

from .local_module import helper_function


class MyClass:
    """Class docstring."""

    CONSTANT_VALUE = "uppercase"

    def __init__(self, name: str) -> None:
        """Initialize instance."""
        self.name = name
        self._private_attr = None

    def public_method(self) -> str:
        """Public method with proper spacing."""
        return f"Hello, {self.name}!"

    def _private_method(self) -> None:
        """Private method with underscore prefix."""
        pass


def standalone_function(param: str) -> bool:
    """Function with type hints and proper naming."""
    return len(param) > 0
```

## PEP 440 Compliance (Version Identification)

### Semantic Versioning Integration

Our template uses PEP 440-compliant version identifiers with semantic versioning:

#### Version Format

```
X.Y.Z[{a|b|rc}N]
```

**Examples:**

-   `0.1.0` - Normal release
-   `1.0.0a1` - Alpha release
-   `1.0.0b2` - Beta release
-   `1.0.0rc1` - Release candidate
-   `2.1.3` - Patch release

#### Version Management

**Location:** `src/template_python_project/__init__.py`

```python
__version__ = "0.1.0"
```

**Automated updates:** Python Semantic Release handles version bumps based on conventional commits:

-   `feat:` → Minor version (0.1.0 → 0.2.0)
-   `fix:` → Patch version (0.1.0 → 0.1.1)
-   `feat!:` or `BREAKING CHANGE:` → Major version (0.1.0 → 1.0.0)

#### Configuration in pyproject.toml

```toml
[tool.setuptools.dynamic]
version = {attr = "template_python_project.__version__"}

[tool.semantic_release]
version_variables = [
    "src/template_python_project/__init__.py:__version__",
]
```

### Pre-release Versioning

PEP 440 compliant pre-release versions are supported:

```python
# Examples of valid PEP 440 versions
"1.0.0a1"    # Alpha
"1.0.0b1"    # Beta
"1.0.0rc1"   # Release candidate
"2.0.0.dev1" # Development release
```

## Automation and Enforcement

### Pre-commit Hooks

**Configuration:** `.pre-commit.yaml`

Automatically runs before each commit:

```yaml
repos:
    - repo: https://github.com/psf/black
      rev: 25.1.0
      hooks:
          - id: black

    - repo: https://github.com/charliermarsh/ruff-pre-commit
      rev: v0.12.3
      hooks:
          - id: ruff

    - repo: https://github.com/pre-commit/mirrors-mypy
      rev: v1.16.1
      hooks:
          - id: mypy
```

### CI/CD Pipeline Enforcement

**GitHub Actions workflows enforce compliance:**

1. **PR Validation Workflow** (`pr-validation.yml`):

    ```yaml
    - name: Lint with Ruff
      run: ruff check src/

    - name: Format with Black
      run: black --check src/

    - name: Type check with mypy
      run: mypy src/
    ```

2. **Cross-platform testing** ensures compliance across Ubuntu, Windows, and macOS

### Local Development Commands

#### Check code quality:

```bash
# Run all quality checks
pre-commit run --all-files

# Individual tools
black --check src/          # Check formatting
black src/                  # Apply formatting
ruff check src/             # Lint code
ruff check src/ --fix       # Auto-fix issues
mypy src/                   # Type checking
```

#### Verify version compliance:

```bash
# Check current version
python -c "from template_python_project import __version__; print(__version__)"

# Validate version format (PEP 440)
python -c "
import packaging.version
from template_python_project import __version__
try:
    packaging.version.Version(__version__)
    print(f'✓ Version {__version__} is PEP 440 compliant')
except packaging.version.InvalidVersion as e:
    print(f'✗ Invalid version: {e}')
"
```

## Enhanced Configuration Options

### Advanced Ruff Configuration

For stricter compliance, consider enabling additional rules:

```toml
[tool.ruff]
line-length = 88
target-version = "py313"
select = [
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "F",    # pyflakes
    "I",    # isort
    "B",    # flake8-bugbear
    "C4",   # flake8-comprehensions
    "UP",   # pyupgrade
    "N",    # pep8-naming
    "D",    # pydocstyle
    "S",    # flake8-bandit (security)
]
ignore = [
    "E501",  # line too long (handled by Black)
    "D100",  # missing docstring in public module
    "S101",  # use of assert
]

# Per-file ignores
[tool.ruff.per-file-ignores]
"tests/*" = ["S101", "D"]  # Allow assert and skip docstrings in tests
"__init__.py" = ["D104"]   # Skip docstring requirement for __init__.py
```

### MyPy Strict Mode

For maximum type safety:

```toml
[tool.mypy]
python_version = "3.13"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
warn_unused_ignores = true
show_error_codes = true
```

## Testing Quality Standards

### Test Code Style

Test files follow the same PEP 8 standards:

```python
"""Test module following PEP 257 docstring conventions."""

import pytest

from template_python_project import hello


def test_hello() -> None:
    """Test that hello returns the expected greeting."""
    assert hello() == "Hello, world!"


def test_hello_return_type() -> None:
    """Test that hello returns a string."""
    result = hello()
    assert isinstance(result, str)


@pytest.mark.parametrize("input_val,expected", [
    ("world", "Hello, world!"),
    ("Python", "Hello, Python!"),
])
def test_hello_parameterized(input_val: str, expected: str) -> None:
    """Test hello function with different inputs."""
    # This is an example - actual function doesn't take parameters
    assert len(input_val) > 0  # Placeholder assertion
```

### Quality Metrics

Our CI enforces these quality standards:

-   **Test coverage:** Minimum 80% (configurable in `pyproject.toml`)
-   **Type coverage:** 100% type annotations required
-   **Linting:** Zero violations allowed
-   **Formatting:** Consistent across all files

## IDE Integration

### VS Code Configuration

The template includes `.vscode/settings.json`:

```json
{
    "python.defaultInterpreterPath": ".venv/bin/python",
    "python.formatting.provider": "black",
    "python.linting.enabled": true,
    "python.linting.ruffEnabled": true,
    "python.linting.mypyEnabled": true,
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    }
}
```

### PyCharm Configuration

1. **File → Settings → Tools → External Tools**
2. Add Black, Ruff, and MyPy as external tools
3. **File → Settings → Editor → Code Style → Python**
4. Set line length to 88
5. Enable "Optimize imports on the fly"

## Benefits of Compliance

### PEP 8 Benefits

-   **Readability:** Consistent code style across the project
-   **Maintainability:** Easier for team members to understand code
-   **Onboarding:** New developers can quickly adapt to codebase
-   **Tool compatibility:** Works well with IDE features and analysis tools

### PEP 440 Benefits

-   **Dependency management:** Clear version constraints in requirements
-   **Package distribution:** Compatible with PyPI and other repositories
-   **Semantic meaning:** Version numbers convey compatibility information
-   **Tool support:** Works with pip, setuptools, and packaging tools

### Automation Benefits

-   **Consistency:** No manual style decisions needed
-   **Speed:** Automatic formatting and linting saves time
-   **Quality:** Catches issues before they reach production
-   **Integration:** Works seamlessly with CI/CD and development workflows

## Continuous Improvement

### Keeping Tools Updated

The template uses Dependabot to keep formatting and linting tools current:

```yaml
# .github/dependabot.yml
version: 2
updates:
    - package-ecosystem: "pip"
      directory: "/"
      schedule:
          interval: "weekly"
```

### Monitoring Compliance

Use these commands to verify ongoing compliance:

```bash
# Weekly compliance check
pre-commit run --all-files
pytest --cov=src --cov-report=term-missing

# Version validation
python -c "
import packaging.version
from template_python_project import __version__
print(f'Version: {__version__}')
print(f'PEP 440 compliant: {packaging.version.Version(__version__)}')
"

# Generate quality report
ruff check src/ --output-format=json > quality-report.json
mypy src/ --txt-report mypy-report/
```

This comprehensive approach ensures that projects built from this template maintain high code quality standards while remaining maintainable and professional.
