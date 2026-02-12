#!/bin/bash

if command -v ctop &>/dev/null; then
  echo "ctop is already installed"
  return 0
fi

echo "Installing ctop"

# Install ctop via Homebrew
brew install ctop
