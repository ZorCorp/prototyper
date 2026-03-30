#!/bin/bash
# Deploy .prototyper/ to GitHub Pages
# Usage: bash scripts/deploy-ghpages.sh

set -e

# Check we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: not in a git repo"
  exit 1
fi

# Check .prototyper exists
if [ ! -f ".prototyper/index.html" ]; then
  echo "Error: .prototyper/index.html not found"
  exit 1
fi

# Get repo info
GH_USER=$(gh api user -q '.login' 2>/dev/null || echo "unknown")
REPO=$(basename "$(git rev-parse --show-toplevel)")
BRANCH=$(git branch --show-current)

# Commit and push
git add .prototyper/
git diff --cached --quiet 2>/dev/null || git commit -m "feat: add interactive product demo (Prototyper)"
git push origin "$BRANCH"

# Output URL
URL="https://${GH_USER}.github.io/${REPO}/.prototyper/index.html"
echo ""
echo "============================================"
echo "  Demo deployed!"
echo "  ${URL}"
echo "============================================"
echo ""
echo "Note: GitHub Pages may take 1-2 minutes to propagate."
