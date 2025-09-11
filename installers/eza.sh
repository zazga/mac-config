#!/bin/bash

set -e
set -u

brew install eza

# Determine shell config file
SHELL_NAME="$(basename "$SHELL")"
if [ "$SHELL_NAME" = "zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
  SHELL_RC="$HOME/.bashrc"
else
  echo "Unsupported shell: $SHELL_NAME"
  exit 1
fi

# Define aliases
ALIASES=$(
  cat <<'EOF'
# >>> eza aliases >>>
# Basic setup
alias ls='eza'
alias l='eza -lbF --git'
alias ll='eza -lbGF --git'
alias llm='eza -lbGd --git --sort=modified'
alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'

# Specialty views
alias lS='eza -1'
alias lt='eza --tree --level=2'
alias l.="eza -a | grep -E '^\.'"

# Advanced setup (overrides)
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --icons --octal-permissions --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons'
alias la='eza --long --all --group --group-directories-first'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
alias lS='eza -1 --color=always --group-directories-first --icons'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"
# <<< eza aliases <<<
EOF
)

# Avoid duplicating aliases
if ! grep -q "# >>> eza aliases >>>" "$SHELL_RC"; then
  echo "Adding eza aliases to $SHELL_RC"
  echo "" >>"$SHELL_RC"
  echo "$ALIASES" >>"$SHELL_RC"
  echo "Done. Please restart your shell or run: source $SHELL_RC"
else
  echo "eza aliases already exist in $SHELL_RC"
fi
