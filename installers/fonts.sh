#!/usr/bin/env zsh
if [[ "$PACKAGE_MANAGER" == brew ]]; then
  brew list --cask font-caskaydia-mono-nerd-font >/dev/null 2>&1 && return 0
  brew install --cask font-caskaydia-mono-nerd-font || return 1
else
  if find "$HOME/Library/Fonts" /Library/Fonts -iname '*Caskaydia*' -print -quit 2>/dev/null | grep -q .; then return 0; fi
  print "⚠ Nerd Font not installed via MacPorts; install Caskaydia manually: https://www.nerdfonts.com/font-downloads"
  return 0
fi
