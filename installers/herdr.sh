#!/usr/bin/env zsh
install "herdr" || return 1
# Codex integration is optional; do not install coding agents implicitly.
if command -v codex >/dev/null 2>&1; then
  herdr integration install codex || return 1
fi
