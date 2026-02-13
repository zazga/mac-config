#!/bin/bash

if command -v lazygit &>/dev/null; then
  echo "lazygit is already installed"
  return 0
fi

echo "Installing lazygit"

# Install lazygit via Homebrew
brew install lazygit
