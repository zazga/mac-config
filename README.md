# mac-config

Personal macOS bootstrap repository for setting up a development environment with shell dotfiles, application config, command-line tools, and a desktop wallpaper.

The main entry point is `install.sh`. It copies the tracked dotfiles and config files into the current user's home directory, runs every installer script in `installers/`, and applies the included wallpaper.

## What it does

`install.sh` performs the following steps:

1. Copies files from `dotfiles/` into `$HOME/.zsh/`.
2. Moves the copied `.zshrc` from `$HOME/.zsh/.zshrc` to `$HOME/.zshrc`.
3. Copies files from `.config/` into `$HOME/.config/` while preserving their relative paths.
4. Runs every shell script in `installers/*.sh`.
5. Copies the bundled wallpaper into `$HOME/.config/wallpapers/`.
6. Sets the wallpaper for every desktop using `osascript`.

When an existing destination file differs from the repository version, the script creates a `.backup` file before overwriting it.

## Requirements

This repository is intended for macOS.

Before running it, make sure you have:

- macOS
- `bash`
- `zsh`
- Git
- Homebrew
- permission to install tools with Homebrew
- `sudo` access for installers that require it, such as the Podman mac-helper

## Usage

Clone the repository:

```bash
git clone https://github.com/zazga/mac-config.git
cd mac-config
```

Run the installer:

```bash
chmod +x install.sh
./install.sh
```

The script uses `set -e`, so it stops when a command fails.

## Repository layout

```text
.
├── install.sh              # Main bootstrap script
├── installers/             # One installer script per tool
├── dotfiles/               # Shell dotfiles copied into the home directory
├── .config/                # Config files copied into ~/.config
└── resources/backgrounds/  # Wallpaper assets
```

## Installed tools

The `installers/` directory contains separate scripts for tools such as:

- Alacritty
- Atuin
- bat
- ctop
- cronboard
- eza
- fd
- fx
- fzf
- Go
- kubectl
- kustomize
- lazydocker
- lazygit
- Neovim
- Podman
- ripgrep (`rg`)
- Starship
- Tekton CLI (`tkn`)
- tldr
- uv
- yamllint
- yq
- zoxide
- fonts

Most installers first check whether the command already exists and skip installation when it does.

## Adding a new installer

Add a new executable shell script to `installers/`:

```bash
#!/usr/bin/env bash
set -euo pipefail

if command -v example &>/dev/null; then
  echo "example is already installed"
  exit 0
fi

echo "Installing example..."
brew install example
```

The main installer automatically runs every `*.sh` file in `installers/`:

```bash
for script in ./installers/*.sh; do
  [ -f "$script" ] || continue
  [ -x "$script" ] || chmod +x "$script"
  echo "Running: $script"
  "$script"
done
```

Because installer scripts are executed as separate processes, use `exit 0` instead of `return 0` unless the installer logic is inside a function.

## Notes

### Homebrew casks

For regular CLI tools, `command -v <tool>` is usually a good installation check. For Homebrew casks, this can be unreliable because casks often install a `.app` bundle instead of placing a command in `$PATH`.

For example, Alacritty may exist as:

```text
/Applications/Alacritty.app
```

A more reliable check for a cask is:

```bash
if brew list --cask alacritty &>/dev/null || [[ -d "/Applications/Alacritty.app" ]]; then
  echo "alacritty is already installed"
  exit 0
fi
```

### Backups

Existing dotfiles and config files are backed up only when their contents differ from the repository version. Backups are written next to the original file with a `.backup` suffix.

### Re-running the installer

The installer is intended to be re-runnable, but individual installers may still perform extra setup steps depending on the tool. Review scripts in `installers/` before running on an existing machine.

## License

No license has been specified yet.
