#!/bin/bash

if command -v fzf &>/dev/null; then
  echo "fzf is already installed"
  exit 0
fi

echo "Installing fzf"

brew install fzf

# Optional: run install script for key bindings and completions
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc

# Detect the correct shell and config file
if [[ "$SHELL" == */zsh ]]; then
  CONFIG_FILE="$HOME/.zshrc"
  FZF_LINE='[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh'
elif [[ "$SHELL" == */bash ]]; then
  CONFIG_FILE="$HOME/.bashrc"
  FZF_LINE='[ -f ~/.fzf.bash ] && source ~/.fzf.bash'
else
  # Fallback (default to bash)
  CONFIG_FILE="$HOME/.bashrc"
  FZF_LINE='[ -f ~/.fzf.bash ] && source ~/.fzf.bash'
fi

# Add the line only if it's not already there
if ! grep -Fxq "$FZF_LINE" "$CONFIG_FILE"; then
  echo -e "\n# fzf configuration\n$FZF_LINE" >>"$CONFIG_FILE"
  echo "Added fzf init line to $CONFIG_FILE"
else
  echo "fzf init line already exists in $CONFIG_FILE"
fi
