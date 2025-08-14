$ErrorActionPreference = "Stop"

$requiredPython = "3.13"
$pythonBin = "python"

# Check Python version
$pythonVersion = & $pythonBin -c "import sys; print('.'.join(map(str, sys.version_info[:2])))"
if ([version]$pythonVersion -lt [version]$requiredPython) {
    Write-Host "Python $requiredPython or higher is required. Found $pythonVersion."
    exit 1
}

# Create .venv if it doesn't exist
if (-not (Test-Path ".venv")) {
    & $pythonBin -m venv .venv
    Write-Host "Created virtual environment in .venv"
}

# Activate venv and install dependencies
& .\.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install -e ".[dev]"

# Ensure pre-commit is installed
if (-not (pip show pre-commit)) {
    Write-Host "pre-commit not found. Installing..."
    pip install pre-commit
}

# Install pre-commit hooks
pre-commit install

Write-Host "Bootstrap complete. Activate your environment with: .\.venv\Scripts\Activate.ps1"
