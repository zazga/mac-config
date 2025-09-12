#!/bin/bash

if command -v alacritty &>/dev/null; then
  echo "alacritty is already installed"
  exit 0
fi

echo "Installing alacritty..."

brew install --cask alacritty
