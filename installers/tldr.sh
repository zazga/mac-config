#!/bin/bash

if command -v tldr &>/dev/null; then
  echo "tldr is already installed"
  exit 0
fi

echo "Installing tldr"

# Install tldr via Homebrew
# The rust client is called tlrc
brew install tlrc
