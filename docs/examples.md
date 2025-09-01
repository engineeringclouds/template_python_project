# Template Usage Examples

This document provides comprehensive examples for using the template_python_project template to create robust Python applications.

## 🚀 Quick Start Projects

### Example 1: CLI Tool

Transform the template into a command-line interface tool:

```python
# src/my_cli_tool/main.py
import argparse
from typing import Optional

def greet(name: str, formal: bool = False) -> str:
    """Generate a greeting message."""
    greeting = "Good day" if formal else "Hello"
    return f"{greeting}, {name}!"

def main():
    parser = argparse.ArgumentParser(description="A friendly greeting tool")
    parser.add_argument("name", help="Name to greet")
    parser.add_argument("--formal", action="store_true", help="Use formal greeting")

    args = parser.parse_args()
    print(greet(args.name, args.formal))

if __name__ == "__main__":
    main()
```

**Usage:**

```sh
python -m my_cli_tool Alice
# Output: Hello, Alice!

python -m my_cli_tool Bob --formal
# Output: Good day, Bob!
```

### Example 2: Web API with FastAPI

Convert the template to a web service:

```python
# src/my_api/main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Dict, Any

app = FastAPI(title="My API", description="Template-based API")

class GreetingRequest(BaseModel):
    name: str
    language: str = "en"

class GreetingResponse(BaseModel):
    message: str
    language: str

GREETINGS: Dict[str, str] = {
    "en": "Hello, {}!",
    "es": "¡Hola, {}!",
    "fr": "Bonjour, {}!",
    "de": "Hallo, {}!"
}

@app.get("/")
async def root() -> Dict[str, str]:
    return {"message": "Welcome to My API"}

@app.post("/greet", response_model=GreetingResponse)
async def greet(request: GreetingRequest) -> GreetingResponse:
    if request.language not in GREETINGS:
        raise HTTPException(
            status_code=400,
            detail=f"Language '{request.language}' not supported"
        )

    message = GREETINGS[request.language].format(request.name)
    return GreetingResponse(message=message, language=request.language)

def main():
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

if __name__ == "__main__":
    main()
```

**Dependencies to add:**

```toml
# pyproject.toml - Add to dependencies
dependencies = [
    "fastapi>=0.104.0",
    "uvicorn[standard]>=0.24.0",
]
```

### Example 3: Data Processing Tool

Transform into a data analysis application:

```python
# src/data_processor/main.py
import pandas as pd
import json
from pathlib import Path
from typing import Dict, List, Any

def process_csv(file_path: Path) -> Dict[str, Any]:
    """Process a CSV file and return summary statistics."""
    try:
        df = pd.read_csv(file_path)

        summary = {
            "filename": file_path.name,
            "rows": len(df),
            "columns": len(df.columns),
            "column_info": {
                col: {
                    "type": str(df[col].dtype),
                    "null_count": df[col].isnull().sum(),
                    "unique_count": df[col].nunique()
                }
                for col in df.columns
            }
        }

        # Add numeric column statistics
        numeric_cols = df.select_dtypes(include=['number']).columns
        if len(numeric_cols) > 0:
            summary["numeric_stats"] = df[numeric_cols].describe().to_dict()

        return summary

    except Exception as e:
        return {"error": str(e), "filename": file_path.name}

def main():
    import sys
    if len(sys.argv) < 2:
        print("Usage: python -m data_processor <csv_file>")
        sys.exit(1)

    file_path = Path(sys.argv[1])
    if not file_path.exists():
        print(f"Error: File {file_path} not found")
        sys.exit(1)

    result = process_csv(file_path)
    print(json.dumps(result, indent=2, default=str))

if __name__ == "__main__":
    main()
```

## 🧪 Advanced Testing Examples

### Example: Testing CLI Applications

```python
# tests/test_cli.py
import pytest
from click.testing import CliRunner
from my_cli_tool.main import main

def test_cli_basic_greeting():
    """Test basic CLI functionality."""
    runner = CliRunner()
    result = runner.invoke(main, ['Alice'])

    assert result.exit_code == 0
    assert "Hello, Alice!" in result.output

def test_cli_formal_greeting():
    """Test formal greeting option."""
    runner = CliRunner()
    result = runner.invoke(main, ['Bob', '--formal'])

    assert result.exit_code == 0
    assert "Good day, Bob!" in result.output

@pytest.fixture
def temp_csv(tmp_path):
    """Create a temporary CSV file for testing."""
    csv_content = """name,age,city
Alice,25,New York
Bob,30,London
Charlie,35,Tokyo"""

    csv_file = tmp_path / "test_data.csv"
    csv_file.write_text(csv_content)
    return csv_file

def test_csv_processing(temp_csv):
    """Test CSV processing functionality."""
    from data_processor.main import process_csv

    result = process_csv(temp_csv)

    assert result["rows"] == 3
    assert result["columns"] == 3
    assert "name" in result["column_info"]
    assert result["column_info"]["age"]["type"] == "int64"
```

### Example: API Testing

```python
# tests/test_api.py
import pytest
from fastapi.testclient import TestClient
from my_api.main import app

@pytest.fixture
def client():
    """Create test client."""
    return TestClient(app)

def test_root_endpoint(client):
    """Test root endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to My API"}

def test_greet_endpoint(client):
    """Test greeting endpoint."""
    response = client.post(
        "/greet",
        json={"name": "Alice", "language": "en"}
    )
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "Hello, Alice!"
    assert data["language"] == "en"

def test_greet_unsupported_language(client):
    """Test error handling for unsupported language."""
    response = client.post(
        "/greet",
        json={"name": "Alice", "language": "xx"}
    )
    assert response.status_code == 400
    assert "not supported" in response.json()["detail"]
```

## 🐳 Container Examples

### Example: Multi-Stage Production Dockerfile

```dockerfile
# Dockerfile.production
# Stage 1: Builder
FROM python:3.13-slim as builder

WORKDIR /build

# Install build dependencies
RUN pip install --upgrade pip build

# Copy project files
COPY pyproject.toml README.md ./
COPY src/ ./src/

# Build wheel
RUN python -m build --wheel

# Stage 2: Runtime
FROM python:3.13-slim as runtime

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set working directory
WORKDIR /app

# Copy wheel from builder stage
COPY --from=builder /build/dist/*.whl .

# Install application
RUN pip install --no-cache-dir *.whl && rm *.whl

# Switch to non-root user
USER appuser

# Set entrypoint
ENTRYPOINT ["python", "-m"]
CMD ["my_package_name"]
```

### Example: Development Docker Compose

```yaml
# docker-compose.dev.yml
version: "3.8"

services:
    app:
        build:
            context: .
            dockerfile: Dockerfile.dev
        volumes:
            - .:/app
            - /app/.venv # Exclude virtual env from sync
        environment:
            - PYTHONPATH=/app/src
            - DEBUG=true
        ports:
            - "8000:8000"
        command: python -m my_api.main

    database:
        image: postgres:15
        environment:
            POSTGRES_DB: myapp
            POSTGRES_USER: dev
            POSTGRES_PASSWORD: dev
        ports:
            - "5432:5432"
        volumes:
            - postgres_data:/var/lib/postgresql/data

volumes:
    postgres_data:
```

## 🚀 GitHub Actions Examples

### Example: Custom Deployment Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
    release:
        types: [published]

jobs:
    deploy:
        runs-on: ubuntu-latest
        if: github.event.release.prerelease == false

        steps:
            - uses: actions/checkout@v4

            - name: Set up Python
              uses: actions/setup-python@v5
              with:
                  python-version: "3.13"

            - name: Build application
              run: |
                  pip install build
                  python -m build

            - name: Deploy to PyPI
              uses: pypa/gh-action-pypi-publish@release/v1
              with:
                  password: ${{ secrets.PYPI_API_TOKEN }}

            - name: Deploy to production server
              run: |
                  # Add your deployment commands here
                  echo "Deploying version ${{ github.event.release.tag_name }}"
```

### Example: Performance Testing Workflow

```yaml
# .github/workflows/performance.yml
name: Performance Tests

on:
    pull_request:
        paths:
            - "src/**"
            - "tests/performance/**"

jobs:
    performance:
        runs-on: ubuntu-latest

        steps:
            - uses: actions/checkout@v4

            - name: Set up Python
              uses: actions/setup-python@v5
              with:
                  python-version: "3.13"

            - name: Install dependencies
              run: |
                  pip install -e ".[dev]"
                  pip install pytest-benchmark

            - name: Run performance tests
              run: |
                  pytest tests/performance/ --benchmark-json=benchmark.json

            - name: Store benchmark results
              uses: benchmark-action/github-action-benchmark@v1
              with:
                  tool: "pytest"
                  output-file-path: benchmark.json
                  github-token: ${{ secrets.GITHUB_TOKEN }}
                  auto-push: true
```

## 🔧 Configuration Examples

### Example: Environment-based Configuration

```python
# src/my_app/config.py
import os
from pathlib import Path
from typing import Optional

class Config:
    """Application configuration."""

    def __init__(self):
        self.debug = os.getenv("DEBUG", "false").lower() == "true"
        self.log_level = os.getenv("LOG_LEVEL", "INFO")
        self.database_url = os.getenv("DATABASE_URL", "sqlite:///app.db")
        self.api_key = os.getenv("API_KEY")
        self.max_workers = int(os.getenv("MAX_WORKERS", "4"))

    @classmethod
    def from_file(cls, config_path: Path) -> "Config":
        """Load configuration from file."""
        import json

        config = cls()
        if config_path.exists():
            with open(config_path) as f:
                file_config = json.load(f)
                for key, value in file_config.items():
                    if hasattr(config, key):
                        setattr(config, key, value)
        return config

    def validate(self) -> None:
        """Validate configuration."""
        if not self.api_key and not self.debug:
            raise ValueError("API_KEY is required in production mode")

# Usage in main.py
def main():
    config = Config()
    config.validate()

    # Use configuration
    if config.debug:
        print("Running in debug mode")
```

### Example: Advanced pyproject.toml

```toml
[project]
name = "my-awesome-project"
version = "0.1.0"
description = "An awesome project built from template"
authors = [
    {name = "Your Name", email = "your.email@example.com"}
]
dependencies = [
    "click>=8.0.0",
    "requests>=2.31.0",
    "pydantic>=2.0.0",
]
requires-python = ">=3.13"
readme = "README.md"
license = {text = "MIT"}
keywords = ["cli", "tool", "awesome"]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.13",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "pytest-benchmark>=4.0.0",
    "black>=23.0.0",
    "ruff>=0.1.0",
    "mypy>=1.5.0",
    "pre-commit>=3.0.0",
]
web = [
    "fastapi>=0.104.0",
    "uvicorn[standard]>=0.24.0",
]
data = [
    "pandas>=2.0.0",
    "numpy>=1.24.0",
    "matplotlib>=3.7.0",
]

[project.scripts]
my-tool = "my_awesome_project.cli:main"
my-api = "my_awesome_project.api:main"

[project.urls]
Homepage = "https://github.com/yourusername/my-awesome-project"
Documentation = "https://yourusername.github.io/my-awesome-project/"
Repository = "https://github.com/yourusername/my-awesome-project.git"
"Bug Tracker" = "https://github.com/yourusername/my-awesome-project/issues"

[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[tool.pytest.ini_options]
testpaths = ["tests"]
pythonpath = ["src"]
addopts = [
    "--cov=my_awesome_project",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-fail-under=80",
]
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks tests as integration tests",
    "performance: marks tests as performance tests",
]

[tool.coverage.run]
source = ["src"]
omit = [
    "*/tests/*",
    "*/test_*",
    "*/__main__.py",
]

[tool.mypy]
python_version = "3.13"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.ruff]
target-version = "py313"
line-length = 88
select = [
    "E",  # pycodestyle errors
    "W",  # pycodestyle warnings
    "F",  # pyflakes
    "I",  # isort
    "B",  # flake8-bugbear
    "C4", # flake8-comprehensions
    "UP", # pyupgrade
]
ignore = [
    "E501",  # line too long, handled by black
    "B008",  # do not perform function calls in argument defaults
]

[tool.ruff.per-file-ignores]
"tests/*" = ["S101"]  # assert allowed in tests

[tool.black]
target-version = ['py313']
line-length = 88
include = '\.pyi?$'
extend-exclude = '''
/(
  # directories
  \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | build
  | dist
)/
'''
```

These examples demonstrate how the template can be transformed into various types of applications while maintaining the robust development practices and CI/CD pipeline that come built-in with the template.
