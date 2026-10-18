#!/usr/bin/env zsh
if command -v just >/dev/null 2>&1; then return 0; fi
# Keep the existing uv-based install, ensuring uv is available first.
if ! command -v uv >/dev/null 2>&1; then
  source "$repo_root/installers/uv.sh" || return 1
fi
uv tool install rust-just || return 1
rehash
command -v just >/dev/null 2>&1
