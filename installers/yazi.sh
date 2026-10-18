#!/usr/bin/env zsh
install "yazi" || return 1
if [[ -d "$HOME/.config/yazi/plugins/smart-enter.yazi" ]]; then
  print "smart-enter already installed"
elif command -v ya >/dev/null 2>&1; then
  ya pkg add yazi-rs/plugins:smart-enter || return 1
else
  print -u2 "Cannot install smart-enter: 'ya' not found"
  return 1
fi
