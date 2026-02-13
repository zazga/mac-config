#!/bin/bash

if command -v starship &>/dev/null; then
  echo "starship is already installed"
  return 0
fi

echo "Installing starship"

# Install Starship
curl -sS https://starship.rs/install.sh | sh

# Define shell config file and init line
CONFIG_FILE="$HOME/.zshrc"
INIT_LINE='eval "$(starship init zsh)"'

# Add init line if not already present
if ! grep -Fxq "$INIT_LINE" "$CONFIG_FILE"; then
  echo -e "\n# Starship prompt\n$INIT_LINE" >>"$CONFIG_FILE"
  echo "✅ Added Starship init line to $CONFIG_FILE"
else
  echo "ℹ️ Starship init line already present in $CONFIG_FILE"
fi
