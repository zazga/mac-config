#!/bin/bash

# Check of Podman al geïnstalleerd is
if command -v podman &>/dev/null; then
  echo "Podman is already installed"
  return 0
else
  echo "Installing Podman via Homebrew..."
  brew install podman
fi

# Install Podman mac-helper (vereist sudo)
PODMAN_HELPER_PATH=$(brew list podman | grep podman-mac-helper)
if [ -z "$PODMAN_HELPER_PATH" ]; then
  echo "Could not find podman-mac-helper path, aborting."
  exit 1
fi

echo "Installing Podman mac-helper..."
sudo "$PODMAN_HELPER_PATH" install
