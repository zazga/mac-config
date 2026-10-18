#!/usr/bin/env zsh
install_package git-delta delta git-delta || return 1
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global delta.side-by-side true

local config_dir="$HOME/Library/Application Support/lazygit"
local config_file="$config_dir/config.yml"
# yq installer runs after delta alphabetically: install dependency explicitly.
install_package yq || return 1
mkdir -p "$config_dir"
[[ -f "$config_file" ]] || print '{}'> "$config_file"
yq -i '
  .git.paging.colorArg = (.git.paging.colorArg // "always") |
  .git.paging.pager = (.git.paging.pager // "delta --dark --paging=never")
' "$config_file"
