# GitHub CLI Quick Reference

## Installation & Authentication

```bash
# Install GitHub CLI
brew install gh                    # macOS
sudo apt install gh               # Ubuntu
winget install GitHub.cli         # Windows

# Authenticate
gh auth login                      # Interactive login
gh auth login --web               # Web-based login
gh auth status                    # Check authentication status
```

## Repository Management

```bash
# Repository Operations
gh repo create my-repo            # Create new repository
gh repo clone owner/repo          # Clone repository
gh repo fork owner/repo           # Fork repository
gh repo view owner/repo           # View repository details
gh repo delete owner/repo         # Delete repository (careful!)

# Repository Settings
gh repo edit owner/repo \
  --description "New description" \
  --add-topic python \
  --add-topic template \
  --enable-discussions \
  --enable-issues \
  --enable-wiki \
  --template \
  --delete-branch-on-merge \
  --enable-auto-merge \
  --enable-squash-merge

# Repository Information
gh repo list                      # List your repositories
gh repo list owner                # List repositories for a user/org
```

## Issue Management

```bash
# List and View Issues
gh issue list                     # List open issues
gh issue list --state closed     # List closed issues
gh issue list --assignee @me     # List issues assigned to you
gh issue view 123                # View issue #123

# Create and Edit Issues
gh issue create                   # Interactive issue creation
gh issue create \
  --title "Bug report" \
  --body "Description" \
  --label bug \
  --assignee username

gh issue edit 123 \
  --title "New title" \
  --add-label "priority: high"

# Issue Actions
gh issue close 123               # Close issue
gh issue reopen 123              # Reopen issue
gh issue pin 123                 # Pin issue
gh issue transfer 123 owner/repo # Transfer issue
```

## Pull Request Management

```bash
# List and View PRs
gh pr list                       # List open PRs
gh pr list --state merged       # List merged PRs
gh pr view 456                   # View PR #456
gh pr diff 456                   # Show PR diff

# Create PRs
gh pr create                     # Interactive PR creation
gh pr create \
  --title "Feature: new functionality" \
  --body "Description" \
  --label enhancement \
  --reviewer username

# PR Actions
gh pr checkout 456               # Checkout PR branch
gh pr merge 456                  # Merge PR
gh pr merge 456 --squash        # Squash merge
gh pr close 456                  # Close PR
gh pr reopen 456                 # Reopen PR
gh pr ready 456                  # Mark PR as ready
```

## Label Management

```bash
# List Labels
gh label list                    # List all labels
gh label list --search bug       # Search labels

# Create Labels
gh label create "bug" \
  --description "Something isn't working" \
  --color "d73a4a"

gh label create "good first issue" \
  --description "Good for newcomers" \
  --color "7057ff"

# Edit Labels
gh label edit "bug" \
  --description "Confirmed bugs" \
  --color "ff0000"

# Delete Labels
gh label delete "unwanted-label"
```

## Release Management

```bash
# List Releases
gh release list                  # List releases
gh release view v1.0.0          # View specific release

# Create Releases
gh release create v1.0.0 \
  --title "Version 1.0.0" \
  --notes "Release notes" \
  --draft

# Upload Assets
gh release upload v1.0.0 dist/*

# Release Actions
gh release edit v1.0.0 --draft=false  # Publish draft
gh release delete v1.0.0              # Delete release
```

## Workflow Management

```bash
# List Workflows
gh workflow list                 # List workflows
gh workflow view ci.yml          # View workflow details

# Run Workflows
gh workflow run ci.yml           # Trigger workflow
gh workflow run ci.yml \
  --ref feature-branch

# Workflow Runs
gh run list                      # List workflow runs
gh run view 123456              # View run details
gh run rerun 123456             # Rerun workflow
gh run cancel 123456            # Cancel running workflow
```

## API Access

```bash
# Generic API Calls
gh api repos/owner/repo          # GET request
gh api repos/owner/repo \
  --method PATCH \
  --field description="New desc"

# Common API Endpoints
gh api user                      # Current user info
gh api orgs/orgname             # Organization info
gh api repos/owner/repo/issues  # Repository issues
gh api repos/owner/repo/pulls   # Repository PRs

# Paginated Results
gh api repos/owner/repo/issues \
  --paginate \
  --jq '.[].title'
```

## Advanced Features

```bash
# SSH Key Management
gh ssh-key list                  # List SSH keys
gh ssh-key add ~/.ssh/id_rsa.pub # Add SSH key

# GitHub Actions Secrets
gh secret list                   # List secrets
gh secret set SECRET_NAME       # Set secret (prompts for value)

# Gist Management
gh gist create file.txt          # Create gist
gh gist list                     # List your gists
gh gist view gist-id            # View gist

# Codespace Management
gh codespace list                # List codespaces
gh codespace create             # Create codespace
gh codespace ssh                # SSH into codespace
```

## Useful Flags and Options

```bash
# Common Flags
--repo owner/repo               # Specify repository
--json field1,field2           # JSON output
--jq '.[] | .name'             # JQ filtering
--template '{{.title}}'        # Go template formatting
--limit 50                     # Limit results
--state open|closed|merged     # Filter by state

# Output Formats
gh issue list --json number,title,author
gh pr list --template '{{range .}}{{.title}}{{end}}'
gh repo list --json name,description --jq '.[].name'
```

## Environment Variables

```bash
# Authentication
export GH_TOKEN=ghp_xxxxxxxxxxxx    # Personal access token
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx # Alternative token variable

# Configuration
export GH_REPO=owner/repo           # Default repository
export GH_HOST=github.example.com   # GitHub Enterprise
```

## Configuration

```bash
# Set Defaults
gh config set editor vim         # Set default editor
gh config set git_protocol https # Set git protocol
gh config set prompt enabled     # Enable prompts

# View Configuration
gh config list                   # List all config
gh config get editor            # Get specific config
```

## Aliases

```bash
# Create Aliases
gh alias set pv 'pr view'        # gh pv 123
gh alias set co 'pr checkout'    # gh co 123
gh alias set issues 'issue list --assignee @me'

# List Aliases
gh alias list
```

## Tips and Tricks

1. **Use `--help` for any command**: `gh repo create --help`
2. **Combine with other tools**: `gh issue list --json title | jq -r '.[].title'`
3. **Create scripts**: Save complex commands as shell scripts
4. **Use aliases**: Create shortcuts for frequently used commands
5. **Tab completion**: Enable shell completion for faster typing
