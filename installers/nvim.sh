#!/bin/bash

if command -v nvim &>/dev/null; then
  echo "nvim is already installed"
  exit 0
fi

echo "Installing nvim"

set -e # Exit on error
set -u # Treat unset variables as errors

echo "Installing Neovim..."
brew install nvim

NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Backup existing config if it exists
if [ -d "$NVIM_CONFIG_DIR" ]; then
  echo "Backing up existing Neovim config..."
  mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}_backup_$(date +%s)"
fi

echo "Cloning LazyVim starter config..."
git clone https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"

echo "Removing git history..."
rm -rf "$NVIM_CONFIG_DIR/.git"
