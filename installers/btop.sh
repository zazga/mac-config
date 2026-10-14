#!/bin/bash

if command -v btop &>/dev/null; then
  echo "btop is already installed"
  return 0
fi

echo "Installing btop"

# Install btop via Homebrew
brew install btop
