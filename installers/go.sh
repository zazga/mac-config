#!/bin/bash

if command -v go &>/dev/null; then
  echo "go is already installed"
  return 0
fi

echo "Installing go"

# Install go via Homebrew
brew install go
