#!/usr/bin/env bash
# ==============================================================================
# push_to_gitlab_wiki.sh
# Automates cloning your GitLab Wiki repository, copying all wiki markdown docs,
# and pushing them directly to GitLab Wiki.
# ==============================================================================

set -e

WIKI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$WIKI_DIR/../.." && pwd)"
TEMP_DIR="/tmp/unifycloud_wiki_sync_$$"

# Git repository for GitLab Wiki:
WIKI_REPO_HTTPS="https://gitlab.com/leorise25/unifycloud.wiki.git"
WIKI_REPO_SSH="git@gitlab.com:leorise25/unifycloud.wiki.git"

echo "========================================================"
echo "  UnifyCloud - GitLab Wiki Publisher"
echo "========================================================"
echo ""
echo "Source documents directory: $WIKI_DIR"
echo ""

# Determine whether to use SSH or HTTPS
WIKI_REPO="$WIKI_REPO_HTTPS"
if ssh -T git@gitlab.com 2>&1 | grep -q "Welcome to GitLab"; then
    echo "✓ SSH authentication with GitLab detected. Using SSH remote."
    WIKI_REPO="$WIKI_REPO_SSH"
else
    echo "ℹ Using HTTPS remote ($WIKI_REPO_HTTPS)."
    echo "  (You may be prompted for your GitLab username and Personal Access Token)"
fi

echo ""
echo "--> Cloning GitLab Wiki repository into temporary directory..."
rm -rf "$TEMP_DIR"
git clone "$WIKI_REPO" "$TEMP_DIR" || {
    echo ""
    echo "⚠️  Note: If this is the first time you are creating the Wiki, make sure"
    echo "    you have initialized the Wiki by opening: https://gitlab.com/leorise25/unifycloud/-/wikis"
    echo "    and creating an initial page if needed."
    exit 1
}

echo "--> Copying wiki Markdown files..."
cd "$TEMP_DIR"

# Ensure master/main branch exists
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'master')"
if [ "$CURRENT_BRANCH" = "HEAD" ] || [ -z "$CURRENT_BRANCH" ]; then
    CURRENT_BRANCH="master"
    git checkout -b master 2>/dev/null || true
fi

# Copy all .md files (excluding this script)
for file in "$WIKI_DIR"/*.md; do
    if [ -f "$file" ]; then
        filename="$(basename "$file")"
        echo "    + Copying $filename"
        cp "$file" "$TEMP_DIR/"
    fi
done

echo ""
echo "--> Staging changes in git..."
git add .

if git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "ℹ No changes detected between docs/wiki/ and GitLab Wiki. Everything is up to date!"
else
    echo "--> Committing wiki updates..."
    git commit -m "docs: update UnifyCloud wiki documentation [skip ci]"
    
    echo "--> Pushing updates to GitLab Wiki ($CURRENT_BRANCH)..."
    git push origin "$CURRENT_BRANCH"
    echo ""
    echo "🎉 SUCCESS: Wiki documentation published successfully!"
    echo "👉 View your wiki online at: https://gitlab.com/leorise25/unifycloud/-/wikis/home"
fi

# Clean up
rm -rf "$TEMP_DIR"
echo "Done."
