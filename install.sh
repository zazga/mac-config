#!/bin/bash
# Master.sh - running all other shell scripts

echo "Creating backups"
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)" && echo "✔️  .zshrc backup created."

echo "Running installers"

for tool in uv alacritty starship fzf fd bat nvim eza zoxide kustomize yamllint; do
  if ! command -v "$tool" &>/dev/null; then
    echo "Installing $tool..."
    "./installers/$tool.sh"
  else
    echo "$tool is already installed"
  fi
done

echo "Copying configs"
cp ./config_files/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp ./config_files/alacritty/colors.toml ~/.config/alacritty/colors.toml
cp ./config_files/starship/starship.toml ~/.config/starship.toml

echo "Setting background"
mkdir -p ~/.config/wallpapers
cp resources/backgrounds/19852070_6205209.jpg ~/.config/wallpapers/19852070_6205209.jpg
osascript -e 'tell application "System Events" to set picture of every desktop to "~/.config/wallpapers/19852070_6205209.jpg"'
