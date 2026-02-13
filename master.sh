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

for file in "$repo_dotfile_dir"/*(DN); do
  [[ -f "$file" ]] || continue
  dest="$HOME/.zsh/${file:t}"   # :t = basename

  if [[ -f "$dest" ]]; then
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

# Move .zshrc één level omhoog
if [[ -f "$HOME/.zsh/.zshrc" ]]; then
  mv -f "$HOME/.zsh/.zshrc" "$HOME/.zshrc"
  echo "Moved .zshrc -> $HOME/.zshrc"
fi

# -------------------------------
# Config directories kopiëren
# -------------------------------
echo "Backing up and copying config files..."

# Find bestanden, veilige nullglob
while IFS= read -r src; do
  rel_path="${src#$repo_config_dir/}"
  dest="$target_config_dir/$rel_path"

  mkdir -p "${dest:h}"  # :h = dirname

  if [[ -f "$dest" ]]; then
    if ! cmp -s "$src" "$dest"; then
      cp -f "$dest" "$dest.backup"
      echo "Backed up $dest -> $dest.backup"
    else
      echo "$dest is unchanged"
    fi
  fi

  cp -f "$src" "$dest"
  echo "Copied $src -> $dest"
done < <(find "$repo_config_dir" -type f 2>/dev/null)

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
# Wallpaper instellen
# -------------------------------
echo "Setting background..."
mkdir -p "$HOME/.config/wallpapers"

wallpaper_src="resources/backgrounds/19852070_6205209.jpg"
wallpaper_dest="$HOME/.config/wallpapers/19852070_6205209.jpg"

[[ -f "$wallpaper_src" ]] && cp -f "$wallpaper_src" "$wallpaper_dest"

osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "'"$wallpaper_dest"'"'

echo "Installatie voltooid."

