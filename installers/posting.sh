#!/usr/bin/env zsh
command -v posting >/dev/null 2>&1 && return 0
install "go" || return 1
go install github.com/darrenburns/posting/v3/cmd/posting@latest || return 1
rehash
command -v posting >/dev/null 2>&1 || return 1
