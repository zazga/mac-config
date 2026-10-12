#!/bin/bash

if command -v yazi &>/dev/null; then
  echo "yazi is already installed"
else
  echo "Installing yazi"

  # Install yazi via Homebrew
  brew install yazi
fi

# Install smart-enter plugin (Enter opens a directory, or opens a file)
if [ -d "$HOME/.config/yazi/plugins/smart-enter.yazi" ]; then
  echo "yazi plugin smart-enter is already installed"
else
  echo "Installing yazi plugin smart-enter"

  # 'ya pkg' on newer yazi versions, 'ya pack' on older ones
  ya pkg add yazi-rs/plugins:smart-enter 2>/dev/null
fi
