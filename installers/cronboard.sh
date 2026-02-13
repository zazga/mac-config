#!/bin/bash

if command -v cronboard &>/dev/null; then
  echo "cronboard is already installed"
  return 0
fi

echo "Installing cronboard"

# Install cronboard via Homebrew
brew install cronboard
