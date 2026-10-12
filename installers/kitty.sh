#!/bin/bash

if command -v kitty &>/dev/null; then
  echo "kitty is already installed"
  return 0
fi

echo "Installing kitty"

# Install kitty via Homebrew
brew install --cask kitty
