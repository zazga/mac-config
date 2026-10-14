#!/usr/bin/env zsh
# master.zsh - alles in één, sourcable

# -------------------------------
# Stop als script wordt uitgevoerd
# -------------------------------
if [[ "$ZSH_EVAL_CONTEXT" != *:file ]]; then
  print -u2 "use source master.zsh instead"
  return 1
fi

# -------------------------------
# Schone lokale zsh-omgeving
# -------------------------------
emulate -L zsh
setopt PIPE_FAIL NO_UNSET

# -------------------------------
# Variabelen
# -------------------------------
repo_dotfile_dir="./dotfiles"
repo_config_dir="./.config"
target_config_dir="$HOME/.config"

# -------------------------------
# Dotfiles kopiëren
# -------------------------------
echo "Backing up and copying dotfiles..."

mkdir -p "$HOME/.zsh"

# Alle dotfiles behalve .zshrc naar ~/.zsh/
rsync -av \
  --checksum \
  --backup \
  --suffix=".backup" \
  --exclude='*/' \
  --exclude='.zshrc' \
  "$repo_dotfile_dir/" \
  "$HOME/.zsh/"

# .zshrc rechtstreeks naar ~/
if [[ -f "$repo_dotfile_dir/.zshrc" ]]; then
  rsync -av \
    --checksum \
    --backup \
    --suffix=".backup" \
    "$repo_dotfile_dir/.zshrc" \
    "$HOME/.zshrc"
fi
# -------------------------------
# Config directories kopiëren
# -------------------------------
echo "Backing up and copying config files..."

mkdir -p "$target_config_dir"

rsync -av \
  --checksum \
  --backup \
  --suffix=".backup" \
  "$repo_config_dir/" \
  "$target_config_dir/"

# -------------------------------
# Installers uitvoeren
# -------------------------------
echo "Running installers..."

for script in ./installers/*.sh(.N); do
  [[ -x "$script" ]] || chmod +x "$script"
  echo "Sourcing installers: $script"
  source "$script"
done


# -------------------------------
# Centrale Justfile installeren
# -------------------------------
echo "Installing shared justfile..."

mkdir -p "$HOME/Code"

rsync -av \
  --checksum \
  --backup \
  --suffix=".backup" \
  "resources/justfiles/main-justfile" \
  "$HOME/Code/justfile"


# -------------------------------
# Wallpaper instellen
# -------------------------------
echo "Setting background..."
mkdir -p "$HOME/.config/wallpapers"

wallpaper_src="resources/backgrounds/19852070_6205209.jpg"
wallpaper_dest="$HOME/.config/wallpapers/19852070_6205209.jpg"

[[ -f "$wallpaper_src" ]] && cp -f "$wallpaper_src" "$wallpaper_dest"

osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "'"$wallpaper_dest"'"'

echo "Installatie voltooid."

