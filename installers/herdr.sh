#!/bin/bash

if command -v herdr &>/dev/null; then
  echo "herdr is already installed"
else
  echo "Installing herdr"
  brew install herdr
fi

if ! command -v codex &>/dev/null; then
  echo "Installing codex"
  brew install codex
fi

if command -v codex &>/dev/null; then
  echo "Installing herdr integration for codex"
  herdr integration install codex
else
  echo "codex install failed, skipping herdr codex integration"
fi
