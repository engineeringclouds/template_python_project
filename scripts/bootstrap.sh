#!/usr/bin/env bash
set -e

REQUIRED_PYTHON="3.13"
PYTHON_BIN="python3"

# Check Python version
PYTHON_VERSION=$($PYTHON_BIN -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
if [[ $(printf '%s\n' "$REQUIRED_PYTHON" "$PYTHON_VERSION" | sort -V | head -n1) != "$REQUIRED_PYTHON" ]]; then
    echo "Python $REQUIRED_PYTHON or higher is required. Found $PYTHON_VERSION."
    exit 1
fi

# Create .venv if it doesn't exist
if [ ! -d ".venv" ]; then
    $PYTHON_BIN -m venv .venv
    echo "Created virtual environment in .venv"
fi

# Activate venv and install dependencies
source .venv/bin/activate
pip install --upgrade pip
pip install -e ".[dev]"

# Ensure pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo "pre-commit not found. Installing..."
    pip install pre-commit
fi

# Install pre-commit hooks
pre-commit install

echo "Bootstrap complete. Activate your environment with: source .venv/bin/activate"