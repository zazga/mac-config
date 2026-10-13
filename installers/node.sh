#!/bin/bash

if command -v node &>/dev/null; then
  echo "node is already installed"
  return 0
fi

echo "Installing node"

# Install node via Homebrew
brew install node
