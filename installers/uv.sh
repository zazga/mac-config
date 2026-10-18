#!/usr/bin/env zsh
command -v uv >/dev/null 2>&1 && return 0
curl -fsSL https://astral.sh/uv/install.sh | sh || return 1
path=("$HOME/.local/bin" $path)
rehash
command -v uv >/dev/null 2>&1
