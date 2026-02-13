#!/bin/bash

if command -v yq &>/dev/null; then
  echo "yq is already installed"
  return 0
fi

echo "Installing yq"

# Install yq via Homebrew
brew install yq
