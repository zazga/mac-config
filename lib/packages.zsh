# Shared zsh helpers loaded by master.zsh.
init_packages() {
  local arch="$(uname -m)"
  case "${PACKAGE_MANAGER:-auto}" in
    auto)
      if [[ "$arch" == arm64 ]]; then PACKAGE_MANAGER=brew
      elif [[ "$arch" == x86_64 ]]; then PACKAGE_MANAGER=port
      else print -u2 "Unsupported architecture: $arch"; return 1; fi ;;
    brew|port) ;;
    *) print -u2 "Invalid PACKAGE_MANAGER: $PACKAGE_MANAGER"; return 1 ;;
  esac
  if [[ "$PACKAGE_MANAGER" == brew ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
    elif [[ -x /usr/local/bin/brew ]]; then path=(/usr/local/bin /usr/local/sbin $path); fi
    command -v brew >/dev/null || { print -u2 "Install Homebrew: https://brew.sh"; return 1; }
  else
    path=(/opt/local/bin /opt/local/sbin $path)
    [[ -x /opt/local/bin/port ]] || { print -u2 "Install MacPorts: https://www.macports.org/install.php"; return 1; }
  fi
  typeset -U path
  rehash
}

# Install a package without requiring the caller to distinguish CLI tools from apps.
# install <brew name> [executable (default: brew name)] [MacPorts name (default: brew name)]
# Homebrew: prefer a formula when available, otherwise use a cask.
# MacPorts: use the port name. A package-manager receipt also covers GUI apps
# that don't expose a command on PATH.
install() {
  local package="${1:?Missing package name}"
  local executable="${2:-$package}"
  local port_name="${3:-$package}"
  local kind

  if command -v "$executable" >/dev/null 2>&1; then
    print "✓ $executable already installed"
    return 0
  fi

  case "$PACKAGE_MANAGER" in
    brew)
      if [[ -n "$(brew list --formula --versions "$package" 2>/dev/null)" ]]; then
        print "✓ $package already installed (formula)"
        return 0
      fi
      if [[ -n "$(brew list --cask --versions "$package" 2>/dev/null)" ]]; then
        print "✓ $package already installed (cask)"
        return 0
      fi

      if brew info --formula "$package" >/dev/null 2>&1; then
        kind=formula
      elif brew info --cask "$package" >/dev/null 2>&1; then
        kind=cask
      else
        print -u2 "Package not found in Homebrew (formula or cask): $package"
        return 1
      fi
      print "Installing $package ($kind) via Homebrew"
      brew install "--$kind" "$package" || return 1
      rehash
      [[ -n "$(brew list "--$kind" --versions "$package" 2>/dev/null)" ]] || {
        print -u2 "Homebrew did not report $package as installed"
        return 1
      }
      ;;
    port)
      if /opt/local/bin/port installed "$port_name" 2>/dev/null | grep -q '(active)'; then
        print "✓ $port_name already installed (MacPorts)"
        return 0
      fi
      print "Installing $port_name via MacPorts"
      sudo /opt/local/bin/port -b install "$port_name" || return 1
      rehash
      /opt/local/bin/port installed "$port_name" 2>/dev/null | grep -q '(active)' || {
        print -u2 "MacPorts did not report $port_name as active"
        return 1
      }
      ;;
    *)
      print -u2 "Unknown package manager: $PACKAGE_MANAGER"
      return 1
      ;;
  esac
}
