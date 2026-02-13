#!/bin/bash

if command -v fd &>/dev/null; then
  echo "fd is already installed"
  return 0
fi

echo "Installing fd"

brew install fd
