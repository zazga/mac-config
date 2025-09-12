#!/bin/bash

if command -v kustomize &>/dev/null; then
  echo "kustomize is already installed"
  exit 0
fi

echo "Installing kustomize"

# Install kustomize via Homebrew
brew install kustomize
