#!/bin/bash

if command -v alacritty &>/dev/null; then
  echo "alacritty is already installed"
  return 0
fi

echo "Installing alacritty..."

ALACRITTY_VERSION=$(curl -fsSL \
  https://api.github.com/repos/alacritty/alacritty/releases/latest |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$ALACRITTY_VERSION" ]; then
  echo "Failed to determine latest Alacritty version"
  return 1
fi

ALACRITTY_VERSION="${ALACRITTY_VERSION#v}"
DMG="/tmp/Alacritty.dmg"
MOUNT="/Volumes/Alacritty"

echo "Installing Alacritty ${ALACRITTY_VERSION}..."

curl -L --fail --silent --show-error \
  -o "$DMG" \
  "https://github.com/alacritty/alacritty/releases/download/v${ALACRITTY_VERSION}/Alacritty-v${ALACRITTY_VERSION}.dmg"

hdiutil attach "$DMG" -nobrowse -quiet

if [ ! -d "$MOUNT/Alacritty.app" ]; then
  echo "Alacritty.app not found in DMG"
  hdiutil detach "$MOUNT" -quiet 2>/dev/null
  rm -f "$DMG"
  return 1
fi

rm -rf "/Applications/Alacritty.app"
cp -R "$MOUNT/Alacritty.app" /Applications/

hdiutil detach "$MOUNT" -quiet
rm -f "$DMG"

echo "Alacritty ${ALACRITTY_VERSION} installed successfully"
