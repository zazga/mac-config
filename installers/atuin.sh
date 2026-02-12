#!/bin/bash

if command -v atuin &>/dev/null; then
  echo "atuin is already installed"
  return 0
fi

echo "Installing atuin"

# Install atuin via Homebrew
brew install atuin
