#!/bin/bash

if command -v fx &>/dev/null; then
  echo "fx is already installed"
  exit 0
fi

echo "Installing fx"

# Install fx via Homebrew
brew install fx
