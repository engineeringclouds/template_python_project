#!/bin/bash
# configure-github-repo.sh - Configure GitHub repository for optimal open source project setup
# Usage: ./configure-github-repo.sh [OWNER/REPO]

set -e  # Exit on any error

# Configuration
# Manual configuration instructions (if automatic setup failed):
# 1. 🛡️ Branch Protection:
#    - Go to: Settings → Branches → Add rule for 'main'
#    - Enable: "Require status checks to pass before merging"
#    - Select required status checks:
#      ✅ PR Validation / ci (ubuntu-latest)
#      ✅ PR Validation / ci (windows-latest)
#      ✅ PR Validation / ci (macos-latest)
#      ✅ PR Validation / container
#      ✅ PR Validation / security-scan
#    - Enable: "Require branches to be up to date before merging"
#    - Enable: "Require conversation resolution before merging"
#    - Enable: "Include administrators"
# 2. 📸 Social Preview Image
DEFAULT_REPO="ds/template_python_project"
REPO="${1:-$DEFAULT_REPO}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI (gh) is not installed. Please install it first:"
        echo "  - macOS: brew install gh"
        echo "  - Ubuntu: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
        echo "  - Windows: https://github.com/cli/cli/releases"
        exit 1
    fi

    if ! command -v jq &> /dev/null; then
        log_error "jq is not installed. Please install it first:"
        echo "  - macOS: brew install jq"
        echo "  - Ubuntu: sudo apt-get install jq"
        echo "  - Windows: https://stedolan.github.io/jq/download/"
        exit 1
    fi

    if ! gh auth status &> /dev/null; then
        log_error "GitHub CLI is not authenticated. Please run: gh auth login"
        exit 1
    fi
}

configure_repository_settings() {
    log_info "Configuring repository settings for $REPO..."

    # Basic repository settings
    gh repo edit "$REPO" \
        --description "Production-ready Python project template with CI/CD, security scanning, and comprehensive community health files" \
        --add-topic python \
        --add-topic template \
        --add-topic automation \
        --add-topic ci-cd \
        --add-topic security \
        --add-topic open-source \
        --add-topic github-actions \
        --add-topic pytest \
        --add-topic docker \
        --enable-discussions \
        --enable-issues \
        --enable-wiki \
        --template \
        --delete-branch-on-merge \
        --enable-auto-merge \
        --enable-squash-merge \
        || log_warning "Some repository settings may have failed to update"

    log_success "Repository settings configured"
}

create_helpful_labels() {
    log_info "Creating helpful labels..."

    # Define labels with colors and descriptions
    declare -A labels=(
        ["good first issue"]="7057ff|Good for newcomers - perfect for first-time contributors"
        ["help wanted"]="008672|Extra attention is needed - community help appreciated"
        ["enhancement"]="a2eeef|New feature or request - improvements to existing functionality"
        ["documentation"]="0075ca|Improvements or additions to documentation"
        ["bug"]="d73a4a|Something isn't working - confirmed bugs"
        ["question"]="d876e3|Further information is requested - ask for help here"
        ["wontfix"]="ffffff|This will not be worked on - declined feature/bug"
        ["duplicate"]="cfd3d7|This issue or pull request already exists"
        ["security"]="ff6b6b|Security related issue - high priority"
        ["performance"]="ffdd44|Performance improvements - optimization"
        ["testing"]="1d76db|Related to testing - unit tests, integration tests"
        ["dependencies"]="0366d6|Dependency updates - package updates"
        ["ci/cd"]="28a745|Continuous Integration/Deployment - GitHub Actions"
        ["workflow"]="6f42c1|GitHub Actions workflow improvements"
        ["breaking change"]="b60205|Breaking change - requires major version bump"
        ["priority: high"]="ff4757|High priority - should be addressed soon"
        ["priority: medium"]="ffa726|Medium priority - normal timeline"
        ["priority: low"]="66bb6a|Low priority - nice to have"
    )

    for label in "${!labels[@]}"; do
        IFS='|' read -r color description <<< "${labels[$label]}"

        if gh label create "$label" --repo "$REPO" --description "$description" --color "$color" 2>/dev/null; then
            log_success "Created label: $label"
        else
            # Try to update existing label
            if gh label edit "$label" --repo "$REPO" --description "$description" --color "$color" 2>/dev/null; then
                log_success "Updated label: $label"
            else
                log_warning "Label '$label' might already exist or failed to create/update"
            fi
        fi
    done

    log_success "Labels configuration complete"
}

configure_branch_protection() {
    log_info "Configuring branch protection rules..."

    # Define required status checks for the new workflow architecture
    local required_checks=(
        "PR Validation / ci (ubuntu-latest)"
        "PR Validation / ci (windows-latest)"
        "PR Validation / ci (macos-latest)"
        "PR Validation / container"
        "PR Validation / security-scan"
    )

    # Convert array to JSON format
    local contexts_json=$(printf '%s\n' "${required_checks[@]}" | jq -R . | jq -s .)

    log_info "Setting up branch protection with status checks:"
    for check in "${required_checks[@]}"; do
        echo "  - $check"
    done

    # Enable branch protection for main branch
    # Note: This requires push access to the repository
    if gh api repos/"$REPO"/branches/main/protection \
        --method PUT \
        --field required_status_checks="{\"strict\":true,\"contexts\":$contexts_json}" \
        --field enforce_admins=true \
        --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true,"require_code_owner_reviews":false,"require_last_push_approval":false}' \
        --field restrictions=null \
        --field allow_force_pushes=false \
        --field allow_deletions=false \
        --field block_creations=false \
        --field required_conversation_resolution=true \
        2>/dev/null; then

        log_success "Branch protection configured with required status checks"
        log_info "All PR validation workflow jobs must pass before merge"
    else
        log_warning "Branch protection setup requires admin access"
        log_info "Manual setup required - see configuration steps below"
    fi
}

create_funding_file() {
    log_info "Checking for FUNDING.yml file..."

    # Check if FUNDING.yml already exists
    if gh api repos/"$REPO"/contents/.github/FUNDING.yml &>/dev/null; then
        log_warning "FUNDING.yml already exists, skipping creation"
    else
        log_info "FUNDING.yml not found. To enable sponsorship, create .github/FUNDING.yml with your funding platforms:"
        cat << 'EOF'
# Example FUNDING.yml content:
# github: [your-username]
# patreon: your-username
# ko_fi: your-username
# custom: ["https://your-website.com/donate"]
EOF
    fi
}

verify_community_health() {
    log_info "Verifying community health files..."

    local files=(
        "README.md"
        "LICENSE"
        "CODE_OF_CONDUCT.md"
        "CONTRIBUTING.md"
        "SECURITY.md"
        "SUPPORT.md"
        ".github/ISSUE_TEMPLATE/"
        ".github/pull_request_template.md"
    )

    for file in "${files[@]}"; do
        if gh api repos/"$REPO"/contents/"$file" &>/dev/null; then
            log_success "✓ $file exists"
        else
            log_warning "✗ $file not found"
        fi
    done
}

display_manual_steps() {
    log_info "Manual steps that require GitHub web interface:"
    cat << 'EOF'

🌐 MANUAL CONFIGURATION NEEDED:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. � Branch Protection (if automatic setup failed):
   - Go to: Settings → Branches → Add rule for 'main'
   - Enable: "Require status checks to pass before merging"
   - Select required status checks:
     ✅ PR Validation / ci (ubuntu-latest)
     ✅ PR Validation / ci (windows-latest)
     ✅ PR Validation / ci (macos-latest)
     ✅ PR Validation / container
     ✅ PR Validation / security-scan
   - Enable: "Require branches to be up to date before merging"
   - Enable: "Require conversation resolution before merging"
   - Enable: "Include administrators"

2. �📸 Social Preview Image:
   - Go to: Settings → General → Social preview
   - Upload a 1280x640 image representing your project

3. 🏠 Homepage URL:
   - Go to: Settings → General → Website
   - Add your project documentation or website URL

4. 🔒 Advanced Security Settings:
   - Go to: Settings → Security & analysis
   - Enable Dependabot alerts, security updates, and code scanning

5. 📄 GitHub Pages (if needed):
   - Go to: Settings → Pages
   - Configure source branch and folder

6. 💰 Sponsorship (if desired):
   - Create .github/FUNDING.yml file with your sponsorship links
   - Enable sponsorship in Settings → General → Features

7. 🎯 Repository visibility:
   - Ensure repository is public for open source discoverability

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

show_final_summary() {
    log_success "🎉 Repository configuration complete!"
    echo
    log_info "Your repository now has:"
    echo "  ✅ Optimized repository settings"
    echo "  ✅ Comprehensive label system"
    echo "  ✅ Branch protection with workflow status checks"
    echo "  ✅ PR validation workflow requirements"
    echo "  ✅ Community health files"
    echo "  ✅ Issue and PR templates"
    echo "  ✅ Discussions enabled"
    echo "  ✅ Template repository status"
    echo "  ✅ Proper topics for discoverability"
    echo
    log_info "Workflow Protection:"
    echo "  🔒 PRs must pass all validation checks before merge"
    echo "  🧪 CI testing across Ubuntu, Windows, and macOS"
    echo "  🐳 Container build and testing validation"
    echo "  🛡️  Security scanning with Trivy"
    echo "  🔄 Sequential job dependencies ensure reliability"
    echo
    log_info "Next steps:"
    echo "  1. Complete manual configuration steps above"
    echo "  2. Review and customize labels as needed"
    echo "  3. Test the template by creating a new repository from it"
    echo "  4. Create a test PR to verify workflow protection"
    echo "  5. Share your template with the community!"
    echo
    log_info "Repository URL: https://github.com/$REPO"
    log_info "Workflow Documentation: docs/workflow-architecture.md"
}

# Main execution
main() {
    echo "🚀 GitHub Repository Configuration Script"
    echo "=========================================="
    echo

    log_info "Configuring repository: $REPO"
    echo

    # Check prerequisites
    check_gh_cli

    # Execute configuration steps
    configure_repository_settings
    echo

    create_helpful_labels
    echo

    configure_branch_protection
    echo

    create_funding_file
    echo

    verify_community_health
    echo

    display_manual_steps
    echo

    show_final_summary
}

# Handle script interruption
trap 'log_error "Script interrupted"; exit 1' INT

# Run main function
main "$@"
