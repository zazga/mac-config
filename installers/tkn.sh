#!/bin/bash

if command -v tkn &>/dev/null; then
  echo "tkn is already installed"
  exit 0
fi

echo "Installing tkn..."

brew install tektoncd-cli
