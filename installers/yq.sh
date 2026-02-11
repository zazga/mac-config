#!/bin/bash

if command -v yq &>/dev/null; then
  echo "yq is already installed"
  exit 0
fi

echo "Installing yq"

# Install yq via Homebrew
brew install yq
