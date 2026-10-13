#!/bin/bash

if command -v posting &>/dev/null; then
  echo "posting is already installed"
  return 0
fi

echo "Installing posting"

# Install posting via Homebrew
go install github.com/darrenburns/posting/v3/cmd/posting@latest
