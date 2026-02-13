#!/bin/bash

if command -v lazydocker &>/dev/null; then
  echo "lazydocker is already installed"
  return 0
fi

echo "Installing lazydocker"

# Install lazydocker via Homebrew
brew install lazydocker
