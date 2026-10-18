#!/usr/bin/env zsh
# Retain the existing upstream DMG installation, rather than changing to brew/port.
if command -v alacritty >/dev/null 2>&1 || [[ -d /Applications/Alacritty.app ]]; then return 0; fi
local version dmg mount
version="$(curl -fsSL https://api.github.com/repos/alacritty/alacritty/releases/latest | sed -nE 's/.*"tag_name": "v?([^"]+)".*/\1/p' | head -1)"
[[ -n "$version" ]] || { print -u2 "Cannot determine Alacritty version"; return 1; }
dmg="$(mktemp /tmp/Alacritty.XXXXXX.dmg)" || return 1
curl -fLsS -o "$dmg" "https://github.com/alacritty/alacritty/releases/download/v${version}/Alacritty-v${version}.dmg" || { rm -f "$dmg"; return 1; }
mount="$(mktemp -d /tmp/alacritty-mount.XXXXXX)" || return 1
hdiutil attach "$dmg" -mountpoint "$mount" -nobrowse -quiet || { rm -rf "$mount" "$dmg"; return 1; }
if [[ ! -d "$mount/Alacritty.app" ]]; then
  hdiutil detach "$mount" -quiet; rm -rf "$mount" "$dmg"; return 1
fi
ditto "$mount/Alacritty.app" /Applications/Alacritty.app
local result=$?
hdiutil detach "$mount" -quiet
rm -rf "$mount" "$dmg"
return $result
