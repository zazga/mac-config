#!/bin/bash
if brew list zsh-autosuggestions &>/dev/null; then
  echo "zsh-autosuggestions is already installed"
  return 0
fi

echo "Installing zsh-autosuggestions"

brew install zsh-autosuggestions
