#!/bin/bash

if command -v just &>/dev/null; then
  echo "just is already installed"
  return 0
fi

echo "Installing just"

# Install just via uv
uv tool install rust-just
