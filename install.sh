#!/bin/bash
# Master.sh - running all other shell scripts
set -e

repo_dotfile_dir="./dotfiles"
repo_config_dir="./.config"
target_config_dir="$HOME/.config"

# --- Dotfiles to copy ---
echo "Backing up and copying dotfiles..."
for file in "$repo_dotfile_dir"/.* "$repo_dotfile_dir"/*; do
  # skip directories en niet-bestanden
  [ -f "$file" ] || continue

  dest="$HOME/.zsh/${file##*/}" # basename zonder commando

  if [ -f "$dest" ]; then
    if ! cmp -s "$file" "$dest"; then
      cp -f "$dest" "$dest.backup"
      echo "Backed up $dest -> $dest.backup"
    else
      echo "$dest is unchanged"
    fi
  fi

  cp -f "$file" "$dest"
  echo "Copied $file -> $dest"
done

# --- Move .zshrc een folder omhoog ---
mv -f "$HOME/.zsh/.zshrc" "$HOME/.zshrc"
echo "Moved .zshrc -> $HOME/.zshrc"

# --- Config directories ---
echo "Backing up and copying config files..."

find "$repo_config_dir" -type f | while read -r src; do
  rel_path="${src#$repo_config_dir/}"
  dest="$target_config_dir/$rel_path"

  mkdir -p "$(dirname "$dest")"

  if [ -f "$dest" ]; then
    if ! cmp -s "$src" "$dest"; then
      cp -f "$dest" "$dest.backup"
      echo "Backed up $dest -> $dest.backup"
    else
      echo "$dest is unchanged"
    fi
  fi

  cp -f "$src" "$dest"
  echo "Copied $src -> $dest"
done

# --- Installing tools ---
echo "Running installers..."

for script in ./installers/*.sh; do
  [ -f "$script" ] || continue
  [ -x "$script" ] || chmod +x "$script"
  echo "Running: $script"
  "$script"
done

# --- Setting wallpaper ---
echo "Setting background"
mkdir -p ~/.config/wallpapers
cp -f resources/backgrounds/19852070_6205209.jpg ~/.config/wallpapers/19852070_6205209.jpg

osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "'"$HOME/.config/wallpapers/19852070_6205209.jpg"'"'
