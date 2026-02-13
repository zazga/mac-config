#!/bin/bash

if command -v kubectl &>/dev/null; then
  echo "kubectl is already installed"
  return 0
fi

echo "Installing kubectl"

# Install kubectl via Homebrew
brew install kubectl
