#!/bin/bash

if command -v bat &>/dev/null; then
  echo "bat is already installed"
  exit 0
fi

echo "Installing bat"

# Install bat via Homebrew
brew install bat

# Set Zsh-specific variables
CONFIG_FILE="$HOME/.zshrc"
COMPLETION_DIR="$HOME/.zsh/completions"
COMPLETION_FILE="$COMPLETION_DIR/_bat"

# Create completions directory if it doesn't exist
mkdir -p "$COMPLETION_DIR"

# Generate and save Zsh completion script
bat --completion zsh >"$COMPLETION_FILE"
echo "✅ Installed bat Zsh completion to $COMPLETION_FILE"

# Ensure Zsh autoloads from this dir
COMPLETION_INIT="fpath+=('$COMPLETION_DIR')"

if ! grep -Fq "$COMPLETION_INIT" "$CONFIG_FILE"; then
  echo -e "\n# bat completions\n$COMPLETION_INIT" >>"$CONFIG_FILE"
  echo "✅ Added fpath update to $CONFIG_FILE"
else
  echo "ℹ️ fpath already configured in $CONFIG_FILE"
fi
