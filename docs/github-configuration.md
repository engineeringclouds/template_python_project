# GitHub Repository Configuration Guide

This directory contains scripts to help you configure your GitHub repository for optimal open source project management.

## Quick Setup

```bash
# Make the script executable
chmod +x scripts/configure-github-repo.sh

# Run the configuration script
./scripts/configure-github-repo.sh

# Or specify a different repository
./scripts/configure-github-repo.sh your-username/your-repo
```

## What the Script Does

### 🔧 Repository Settings
- Sets description and topics for discoverability
- Enables discussions, issues, and wiki
- Configures merge settings (delete branch on merge, auto-merge, squash merge)
- Marks repository as a template

### 🏷️ Labels
Creates a comprehensive label system including:
- **good first issue** - Perfect for newcomers
- **help wanted** - Community assistance needed
- **enhancement** - New features and improvements
- **documentation** - Documentation improvements
- **bug** - Confirmed bugs
- **security** - Security-related issues
- **performance** - Performance optimizations
- **testing** - Test-related changes
- **dependencies** - Dependency updates
- **ci/cd** - CI/CD pipeline changes
- **priority levels** - high/medium/low priority classification

### 🛡️ Security
- Attempts to configure branch protection rules
- Verifies security-related community health files

### 📋 Community Health
Verifies the presence of:
- README.md
- LICENSE
- CODE_OF_CONDUCT.md
- CONTRIBUTING.md
- SECURITY.md
- SUPPORT.md
- Issue templates
- Pull request template

## Prerequisites

1. **GitHub CLI Installation**
   ```bash
   # macOS
   brew install gh
   
   # Ubuntu/Debian
   curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
   sudo apt update
   sudo apt install gh
   
   # Or download from: https://github.com/cli/cli/releases
   ```

2. **Authentication**
   ```bash
   gh auth login
   ```

## Manual Configuration Required

Some settings require the GitHub web interface:

### 1. Social Preview Image
- Go to **Settings → General → Social preview**
- Upload a 1280×640 image representing your project
- This appears when your repository is shared on social media

### 2. Homepage URL
- Go to **Settings → General → Website**
- Add your project documentation or website URL

### 3. Advanced Security Settings
- Go to **Settings → Security & analysis**
- Enable:
  - Dependabot alerts
  - Dependabot security updates
  - Code scanning (if applicable)

### 4. GitHub Pages (Optional)
- Go to **Settings → Pages**
- Configure source branch and folder for documentation

### 5. Sponsorship (Optional)
- Create `.github/FUNDING.yml` with your sponsorship platforms:
  ```yaml
  github: [your-username]
  patreon: your-username
  ko_fi: your-username
  custom: ["https://your-website.com/donate"]
  ```

## Advanced Usage

### Custom Label Configuration
Edit the `labels` array in the script to customize your label system:

```bash
declare -A labels=(
    ["custom-label"]="color|Description of the label"
)
```

### Repository-Specific Settings
You can modify the script to include repository-specific configurations:

```bash
# Add custom topics
--add-topic your-framework \
--add-topic your-language \
```

### Branch Protection Customization
Modify the branch protection API call to match your workflow requirements:

```bash
gh api repos/"$REPO"/branches/main/protection \
    --method PUT \
    --field required_status_checks='{"strict":true,"contexts":["ci","security-scan"]}' \
    --field required_pull_request_reviews='{"required_approving_review_count":2}'
```

## Troubleshooting

### Authentication Issues
```bash
# Check authentication status
gh auth status

# Re-authenticate if needed
gh auth login --web
```

### Permission Issues
- Ensure you have admin access to the repository
- Some settings (like branch protection) require admin privileges

### Script Execution Issues
```bash
# Make script executable
chmod +x scripts/configure-github-repo.sh

# Check for syntax errors
bash -n scripts/configure-github-repo.sh
```

## GitHub CLI Commands Reference

### Repository Management
```bash
# Edit repository settings
gh repo edit owner/repo --description "New description"

# View repository information
gh repo view owner/repo

# Clone repository
gh repo clone owner/repo
```

### Label Management
```bash
# List labels
gh label list

# Create label
gh label create "new-label" --description "Description" --color "ff0000"

# Edit label
gh label edit "existing-label" --description "New description"

# Delete label
gh label delete "unwanted-label"
```

### Issue and PR Management
```bash
# List issues
gh issue list

# Create issue
gh issue create --title "Issue title" --body "Issue description"

# List pull requests
gh pr list

# Create pull request
gh pr create --title "PR title" --body "PR description"
```

## Best Practices

1. **Run Regularly**: Execute the script when setting up new repositories
2. **Customize Labels**: Adapt the label system to your project's needs
3. **Review Settings**: Regularly review and update repository settings
4. **Document Changes**: Keep track of manual configuration changes
5. **Team Coordination**: Ensure team members understand the label system

## Integration with CI/CD

You can integrate repository configuration into your CI/CD pipeline:

```yaml
name: Configure Repository
on:
  repository_dispatch:
    types: [configure-repo]

jobs:
  configure:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Configure Repository
        run: ./scripts/configure-github-repo.sh
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

This allows you to trigger repository configuration through the GitHub API or manually through the Actions tab.
