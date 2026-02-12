#!/bin/bash

if brew list font-caskaydia-mono-nerd-font &>/dev/null; then
  echo "font-caskaydia-mono-nerd-font is already installed"
  exit 0
fi

echo "Installing font-caskaydia-mono-nerd-font"

# Install fonts via Homebrew
brew install font-caskaydia-mono-nerd-font
