#!/bin/bash

if command -v uv &>/dev/null; then
  echo "uv is already installed"
  exit 0
fi

echo "Installing uv"

curl -LsSf https://astral.sh/uv/install.sh | sh
