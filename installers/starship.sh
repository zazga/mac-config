#!/usr/bin/env zsh
command -v starship >/dev/null 2>&1 && return 0
install "starship" || return 1
# The init call is already tracked in .zshrc_starship.
