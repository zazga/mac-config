#!/usr/bin/env zsh
if [[ "$PACKAGE_MANAGER" == brew ]]; then
  brew list --formula zsh-autosuggestions >/dev/null 2>&1 && return 0
  brew install zsh-autosuggestions
else
  /opt/local/bin/port installed zsh-autosuggestions | grep -q '(active)' && return 0
  sudo /opt/local/bin/port -b install zsh-autosuggestions
fi
