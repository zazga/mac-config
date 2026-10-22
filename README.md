# mac-config

macOS setup for Apple Silicon and Intel using the sourcable zsh entry point `master.sh`.

## Quick start

On Apple Silicon, install [Homebrew](https://brew.sh). On Intel, install [MacPorts](https://www.macports.org/install.php) for your macOS version. On Intel Tahoe, MacPorts binary availability varies; installers use `port -b` and **will not compile from source**.

```zsh
git clone https://github.com/zazga/mac-config.git
cd mac-config
source ./master.sh
```

The script can be sourced from any working directory. Dotfiles and application configuration are copied with rsync backups, then each `installers/*.sh` runs in an isolated subshell to avoid leaking shell options or exiting your terminal. Configuration after installation is retained for Delta/Lazygit, bat completions, Yazi plugins and Podman helper when available. Neovim uses the tracked repository config, not a fresh LazyVim starter clone.

Installer conventions: simple packages call `install_package <brew-name> [command-name] [port-name]`. The helper checks existing executables, selects Homebrew on arm64 or MacPorts on x86_64, and validates the result. Use `PACKAGE_MANAGER=brew source ./master.sh` for an explicit override. Some tools install from upstream scripts, Go or uv and keep their dedicated logic.

A few caveats: fonts require a manual install on Intel; available MacPorts ports and archives differ by macOS and architecture. The installer stops on missing binaries rather than triggering an expensive build. `master.sh` is the supported entry point; the older `install.sh` is legacy.

To use this feature branch:
```zsh
git switch feature/architecture-aware-installers
source ./master.sh
```
