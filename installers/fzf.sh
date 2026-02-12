#!/bin/bash

if command -v fzf &>/dev/null; then
  echo "fzf is already installed"
  return 0
fi

echo "Installing fzf"

brew install fzf

# Optional: run install script for key bindings and completions
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
