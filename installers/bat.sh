#!/usr/bin/env zsh
install "bat" || return 1
local completion_dir="$HOME/.zsh/completions"
mkdir -p "$completion_dir" || return 1
bat --completion zsh > "$completion_dir/_bat" || return 1
# fpath must be set before compinit; configure in tracked dotfiles.
print "bat completions installed"
