#!/usr/bin/env zsh
# Source from any working directory: source /path/to/master.sh
if [[ "$ZSH_EVAL_CONTEXT" != *:file ]]; then
  print -u2 "Use: source master.sh"
  return 1
fi
emulate -L zsh
setopt PIPE_FAIL NO_UNSET
local repo_root="$MAC_CONFIG_ROOT"
local repo_dotfile_dir="$repo_root/dotfiles"
local repo_config_dir="$repo_root/.config"
local target_config_dir="$HOME/.config"

source "$repo_root/lib/packages.zsh"
init_packages || return 1

print "Backing up and copying dotfiles..."
mkdir -p "$HOME/.zsh"
rsync -av --checksum --backup --suffix=".backup" --exclude='*/' --exclude='.zshrc' "$repo_dotfile_dir/" "$HOME/.zsh/" || return 1
if [[ -f "$repo_dotfile_dir/.zshrc" ]]; then
  rsync -av --checksum --backup --suffix=".backup" "$repo_dotfile_dir/.zshrc" "$HOME/.zshrc" || return 1
fi

print "Backing up and copying config files..."
mkdir -p "$target_config_dir"
rsync -av --checksum --backup --suffix=".backup" "$repo_config_dir/" "$target_config_dir/" || return 1

print "Running installers..."
local script
for script in "$repo_root"/installers/*.sh(.N); do
  print "Sourcing installer: $script"
  if ! ( source "$script" ); then
    print -u2 "✗ Installer failed: $script"
    return 1
  fi
done

print "Installing shared justfile..."
mkdir -p "$HOME/Code"
rsync -av --checksum --backup --suffix=".backup" "$repo_root/resources/justfiles/main-justfile" "$HOME/Code/justfile" || return 1

print "Setting background..."
mkdir -p "$HOME/.config/wallpapers"
local wallpaper_src="$repo_root/resources/backgrounds/19852070_6205209.jpg"
local wallpaper_dest="$HOME/.config/wallpapers/19852070_6205209.jpg"
if [[ -f "$wallpaper_src" ]]; then
  cp -f "$wallpaper_src" "$wallpaper_dest" || return 1
  osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "'"$wallpaper_dest"'"' || return 1
fi
print "Installatie voltooid."
