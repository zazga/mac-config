#!/usr/bin/env zsh
install "git-delta" "delta" || return 1
git config --global core.pager delta || return 1
git config --global interactive.diffFilter 'delta --color-only' || return 1
git config --global delta.navigate true || return 1
git config --global delta.line-numbers true || return 1
git config --global delta.side-by-side true || return 1

local config_dir="$HOME/Library/Application Support/lazygit"
local config_file="$config_dir/config.yml"
# yq installer runs after delta alphabetically: install dependency explicitly.
install "yq" || return 1
mkdir -p "$config_dir" || return 1
[[ -f "$config_file" ]] || { print '{}' > "$config_file" || return 1; }
yq -i '
  .git.paging.colorArg = (.git.paging.colorArg // "always") |
  .git.paging.pager = (.git.paging.pager // "delta --dark --paging=never")
' "$config_file" || return 1
