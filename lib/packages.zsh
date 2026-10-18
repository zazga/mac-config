# Shared zsh helpers loaded by master.sh.
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
install_package() {
  local package="${1:?Missing package name}" executable="${2:-$1}" port_name="${3:-$1}"
  if command -v "$executable" >/dev/null 2>&1; then print "✓ $executable already installed"; return 0; fi
  print "Installing $package via $PACKAGE_MANAGER"
  if [[ "$PACKAGE_MANAGER" == brew ]]; then brew install "$package" || return 1
  else sudo /opt/local/bin/port -b install "$port_name" || return 1; fi
  rehash
  command -v "$executable" >/dev/null 2>&1 || { print -u2 "Missing executable: $executable"; return 1; }
}

# GUI applications may install as .app bundles without a PATH executable.
install_app() {
  local package="${1:?Missing application name}"
  local executable="${2:-$1}"
  local port_name="${3:-$1}"
  if command -v "$executable" >/dev/null 2>&1 || [[ -d "/Applications/${package}.app" || -d "$HOME/Applications/${package}.app" ]]; then
    print "✓ $package already installed"
    return 0
  fi
  print "Installing $package via $PACKAGE_MANAGER"
  if [[ "$PACKAGE_MANAGER" == brew ]]; then
    brew install --cask "$package" || return 1
  else
    sudo /opt/local/bin/port -b install "$port_name" || return 1
  fi
  rehash
  if command -v "$executable" >/dev/null 2>&1 || [[ -d "/Applications/${package}.app" || -d "$HOME/Applications/${package}.app" ]]; then
    return 0
  fi
  print -u2 "Installed $package but executable or application was not found"
  return 1
}
