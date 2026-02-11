#!/bin/bash

if command -v rg &>/dev/null; then
  echo "ripgrep is already installed"
  exit 0
fi

echo "Installing ripgrep"

# Install ripgrep via Homebrew
brew install ripgrep
