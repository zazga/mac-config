#!/usr/bin/env zsh
command -v starship >/dev/null 2>&1 && return 0
install_package starship
# The init call is already tracked in .zshrc_starship.
