#!/usr/bin/env zsh
install "podman" || return 1
# mac-helper is optional and needs a vendor-specific executable.
# Preserve existing helper setup only when shipped with the installed package.
local helper
helper="$(command -v podman-mac-helper 2>/dev/null)" || helper=""
if [[ -n "$helper" ]]; then sudo "$helper" install || return 1
else print "Podman installed; optional mac-helper not found (skipping)."; fi
