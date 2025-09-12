#!/bin/bash

if command -v zoxide &>/dev/null; then
  echo "zoxide is already installed"
  exit 0
fi

echo "Installing zoxide"

set -e
set -u

brew install zoxide

# Determine shell and config file
SHELL_NAME="$(basename "$SHELL")"

if [ "$SHELL_NAME" = "zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
  INIT_CMD='eval "$(zoxide init zsh)"'
elif [ "$SHELL_NAME" = "bash" ]; then
  SHELL_RC="$HOME/.bashrc"
  INIT_CMD='eval "$(zoxide init bash)"'
else
  echo "Unsupported shell: $SHELL_NAME"
  echo "You need to manually add zoxide init to your shell config."
  echo 'See https://github.com/ajeetdsouza/zoxide#installation'
  exit 1
fi

# Define zoxide setup block
ZOXIDE_BLOCK=$(
  cat <<'EOF'
# >>> zoxide setup >>>
eval "$(zoxide init zsh)"

# Optional aliases for convenience
alias zz='z'            # quick shortcut to jump
alias zi='zoxide import'  # import directories from autojump or z database
alias cd='z'            # optional: replace cd with z

# >>> zoxide setup <<<
EOF
)

# Check if already present
if grep -q "# >>> zoxide setup >>>" "$SHELL_RC"; then
  echo "zoxide config already exists in $SHELL_RC"
else
  echo "Adding zoxide config to $SHELL_RC"
  echo "" >>"$SHELL_RC"
  echo "$ZOXIDE_BLOCK" >>"$SHELL_RC"
  echo "Done. Please restart your shell or run: source $SHELL_RC"
fi
