#!/bin/bash

# Install git-delta if missing
if command -v delta &>/dev/null; then
  echo "git-delta is already installed"
else
  echo "Installing git-delta"
  brew install git-delta || return 1
fi

# Configure Git Delta
echo "Configuring git-delta"

git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global delta.side-by-side true

# Configure Lazygit
CONFIG_DIR="$HOME/Library/Application Support/lazygit"
CONFIG_FILE="$CONFIG_DIR/config.yml"

if ! command -v yq &>/dev/null; then
  echo "Error: yq is not installed"
  return 1
fi

# Create configuration if missing
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Creating Lazygit configuration"
  mkdir -p "$CONFIG_DIR"
  printf '{}\n' >"$CONFIG_FILE"
fi

# Add missing Delta settings without overwriting existing values
yq -i '
  .git.paging.colorArg = (.git.paging.colorArg // "always") |
  .git.paging.pager = (.git.paging.pager // "delta --dark --paging=never")
' "$CONFIG_FILE" || return 1

echo "git-delta installation and configuration complete"
