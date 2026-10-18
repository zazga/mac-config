#!/usr/bin/env zsh
# master.sh already syncs the tracked LazyVim config; never replace it with starter.
install "neovim" "nvim" || return 1
