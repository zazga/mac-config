#!/bin/bash

if command -v alacritty &>/dev/null; then
  echo "alacritty is already installed"
  return 0
fi

echo "Installing alacritty..."

brew install --cask alacritty
