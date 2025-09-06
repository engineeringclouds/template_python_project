#!/bin/bash
# Test script to verify cyclonedx-py command works with our fix

echo "Testing CycloneDX SBOM generation fix..."

# Check if cyclonedx-bom is installed in dev dependencies
echo "1. Checking if cyclonedx-bom is in pyproject.toml..."
if grep -q "cyclonedx-bom" pyproject.toml; then
    echo "✅ cyclonedx-bom found in pyproject.toml dev dependencies"
else
    echo "❌ cyclonedx-bom NOT found in pyproject.toml"
    exit 1
fi

# Check that this project uses pyproject.toml (not requirements.txt)
echo "2. Verifying project uses pyproject.toml for dependency management..."
if [ -f "pyproject.toml" ] && grep -q "\[project\]" pyproject.toml; then
    echo "✅ Project uses pyproject.toml for dependency management"
else
    echo "❌ pyproject.toml not found or not properly configured"
    exit 1
fi

# Check if requirements.txt exists (it shouldn't for this project)
echo "3. Verifying requirements.txt is not used..."
if [ ! -f "requirements.txt" ] || [ ! -s "requirements.txt" ]; then
    echo "✅ requirements.txt is not used (project uses pyproject.toml)"
else
    echo "⚠️  requirements.txt exists but this project should use pyproject.toml"
fi

# Verify the GitHub Actions workflow has correct commands
echo "4. Verifying GitHub Actions workflow uses correct --output-format and environment subcommand..."
if grep -q "cyclonedx-py environment.*--output-format.*--pyproject" .github/workflows/release.yml; then
    echo "✅ GitHub Actions workflow uses correct environment subcommand with --output-format syntax"
    echo "Commands found:"
    grep "cyclonedx-py environment.*--output-format" .github/workflows/release.yml
else
    echo "❌ GitHub Actions workflow doesn't use correct environment subcommand or --output-format syntax"
    exit 1
fi

# Verify the documentation has correct commands
echo "5. Verifying documentation uses correct --output-format and environment subcommand..."
if grep -q "cyclonedx-py environment.*--output-format.*--pyproject" docs/supply-chain-security.md; then
    echo "✅ Documentation uses correct environment subcommand with --output-format syntax"
    echo "Commands found:"
    grep "cyclonedx-py environment.*--output-format" docs/supply-chain-security.md
else
    echo "❌ Documentation doesn't use correct environment subcommand or --output-format syntax"
    exit 1
fi

# Check if any old --format arguments remain
echo "6. Checking for any remaining --format arguments..."
if grep -r "cyclonedx-py.*--format[^-]" . --exclude-dir=.git; then
    echo "❌ Found remaining --format arguments that should be --output-format"
    exit 1
else
    echo "✅ No remaining --format arguments found"
fi

echo ""
echo "🎉 All checks passed! The CycloneDX commands should now work correctly."
echo ""
echo "The fix includes:"
echo "  - Changed --format to --output-format in GitHub Actions workflow"
echo "  - Changed --format to --output-format in documentation"
echo "  - Changed from 'requirements' to 'environment' subcommand for pyproject.toml projects"
echo "  - Added --pyproject pyproject.toml flag to specify the project file"
echo "  - Using correct format values: JSON and XML (uppercase)"
echo "  - Using cyclonedx-bom package which provides cyclonedx-py command"
echo ""
echo "Note: To actually test the command execution, install dev dependencies with:"
echo "  pip install -e '.[dev]'"
echo "  cyclonedx-py environment -o test-sbom.json --output-format JSON --pyproject pyproject.toml"
