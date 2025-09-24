#!/bin/bash
# Master.sh - running all other shell scripts

# --- Dotfiles to copy ---
dotfiles=(
  "./dotfiles/.zshrc"
  "./dotfiles/.zshrc_homebrew"
  "./dotfiles/.zshrc_nvim"
  "./dotfiles/.zshrc_starship"
  "./dotfiles/.zshrc_fzf"
  "./dotfiles/.zshrc_bat"
  "./dotfiles/.zshrc_eza"
  "./dotfiles/.zshrc_zoxide"
  "./dotfiles/.zshrc_oc"
  "./dotfiles/.zshrc_custom"
  "./dotfiles/.zshrc_alias"
  # Add more dotfiles here as needed
)

echo "Backing up and copying dotfiles..."

for file in "${dotfiles[@]}"; do
  dest="$HOME/$(basename "$file")"

  if [ -f "$dest" ]; then
    cp "$dest" "$dest.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backed up $dest"
  fi

  cp "$file" "$dest" && echo "copied $src -> $dest"
done

# --- Config directories ---
repo_config_dir="./.config"
target_config_dir="$HOME/.config"

echo "Backing up and copying config files from $repo_config_dir to $target_config_dir..."

find "$repo_config_dir" -type f | while read -r src; do
  rel_path="${src#$repo_config_dir/}"
  dest="$target_config_dir/$rel_path"

  mkdir -p "$(dirname "$dest")"

  if [ -f "$dest" ]; then
    cp "$dest" "$dest.backup.$(date +%Y%m%d_%H%M%S)" && echo "Backed up $dest"
  fi

  cp "$src" "$dest" && echo "copied $src -> $dest"
done

# --- Installing tools ---
echo "Running installers..."

for script in ./installers/*.sh; do
  [ -f "$script" ] || continue
  [ -x "$script" ] || chmod +x "$script"
  echo "▶️  Running: $script"
  "$script"
done

# --- Setting wallpaper ---
echo "Setting background"
mkdir -p ~/.config/wallpapers
cp resources/backgrounds/19852070_6205209.jpg ~/.config/wallpapers/19852070_6205209.jpg
osascript -e 'tell application "System Events" to set picture of every desktop to "~/.config/wallpapers/19852070_6205209.jpg"'
