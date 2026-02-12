#!/bin/bash

if command -v atuin &>/dev/null; then
  echo "atuin is already installed"
  exit 0
fi

echo "Installing atuin"

# Install atuin via Homebrew
brew install atuin

# Detect the correct shell and config file
if [[ "$SHELL" == */zsh ]]; then
  CONFIG_FILE="$HOME/.zshrc"
elif [[ "$SHELL" == */bash ]]; then
  CONFIG_FILE="$HOME/.bashrc"
else
  # Fallback (default to bash)
  CONFIG_FILE="$HOME/.bashrc"
fi

ATUIN_LINE='eval "$(atuin init zsh)"'

# add plugin to config file if it isn't there yet
if ! grep -Fxq "$ATUIN_LINE" "$CONFIG_FILE"; then
  echo "$ATUIN_LINE" >>"$CONFIG_FILE"
  echo "installed atuin shell plugin $CONFIG_FILE."
else
  echo "atuin shell plugin already installed."
fi
