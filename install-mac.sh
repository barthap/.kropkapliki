#!/usr/bin/env bash
set -euo pipefail

# Configuration
readonly DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_SUFFIX=".backup-$(date +%Y%m%d-%H%M%S)"
readonly LOG_PREFIX="[dotfiles]"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Utility functions
log_info() {
  echo -e "${GREEN}${LOG_PREFIX}${NC} $*"
}

log_warn() {
  echo -e "${YELLOW}${LOG_PREFIX}${NC} $*"
}

log_error() {
  echo -e "${RED}${LOG_PREFIX}${NC} $*" >&2
}

check_command() {
  command -v "$1" >/dev/null 2>&1
}

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    cp "$file" "${file}${BACKUP_SUFFIX}"
    log_info "Backed up $file"
  fi
}

append_if_missing() {
  local file="$1"
  local content="$2"
  local marker="$3"

  if [[ -f "$file" ]] && grep -qF "$marker" "$file"; then
    log_info "Skipping (already present): $marker"
    return 0
  fi

  backup_file "$file"
  echo "$content" >>"$file"
  log_info "Added to $file"
}

verify_in_dotfiles_dir() {
  if [[ ! -f "$DOTFILES_DIR/install-mac.sh" ]]; then
    log_error "Must run from dotfiles directory. Expected: $HOME/.dotfiles"
    exit 1
  fi
}

# Installation functions
install_homebrew() {
  if check_command brew; then
    log_info "Homebrew already installed"
    return 0
  fi

  log_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Ensure brew is in PATH for rest of script
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_stow() {
  if check_command stow; then
    log_info "Stow already installed"
    return 0
  fi

  log_info "Installing stow..."
  brew install stow
}

setup_homebrew_packages() {
  log_info "Setting up Homebrew packages..."

  verify_in_dotfiles_dir
  cd "$DOTFILES_DIR"

  log_info "Stowing homebrew configuration..."
  stow --target="$HOME" homebrew

  log_info "Installing packages from Brewfile..."
  brew bundle --global --verbose
}

setup_zsh_shell() {
  log_info "Setting up ZSH shell configuration..."

  # Detect brew prefix
  local brew_prefix
  if [[ -d /opt/homebrew ]]; then
    brew_prefix="/opt/homebrew"
  else
    brew_prefix="/usr/local"
  fi

  # Add brew shellenv to .zprofile if not present
  local brew_init="eval \"\$($brew_prefix/bin/brew shellenv)\""
  local brew_comment="# Added by dotfiles install script"
  append_if_missing "$HOME/.zprofile" "$brew_comment
$brew_init" "$brew_init"

  # Source it for current script
  eval "$($brew_prefix/bin/brew shellenv)"
}

stow_packages() {
  log_info "Stowing configuration packages..."

  verify_in_dotfiles_dir
  cd "$DOTFILES_DIR"

  local packages="assorted kitty nvim zsh"
  for pkg in $packages; do
    if [[ -d "$pkg" ]]; then
      log_info "Stowing $pkg..."
      stow --target="$HOME" --restow "$pkg"
    else
      log_warn "Package not found: $pkg"
    fi
  done

  # Karabiner (optional)
  if [[ -d "karabiner" ]]; then
    log_info "Stowing karabiner..."
    stow --target="$HOME" karabiner
  fi
}

install_ohmyzsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log_info "Oh-My-Zsh already installed"
  else
    log_info "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Install plugins
  local custom_plugins="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  if [[ ! -d "$custom_plugins/zsh-autosuggestions" ]]; then
    log_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_plugins/zsh-autosuggestions"
  else
    log_info "zsh-autosuggestions already installed"
  fi

  if [[ ! -d "$custom_plugins/zsh-syntax-highlighting" ]]; then
    log_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_plugins/zsh-syntax-highlighting"
  else
    log_info "zsh-syntax-highlighting already installed"
  fi

  # Change shell to zsh
  if [[ "$SHELL" != "$(which zsh)" ]]; then
    log_info "Changing default shell to zsh..."
    local zsh_path
    zsh_path="$(which zsh)"

    # Add zsh to allowed shells if not present
    if ! grep -qF "$zsh_path" /etc/shells; then
      echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    chsh -s "$zsh_path"
    log_info "Shell changed to zsh (requires logout to take effect)"
  fi
}

install_kitty() {
  if [[ -d "$HOME/.local/kitty.app" ]]; then
    log_info "Kitty already installed"
  else
    log_info "Installing Kitty terminal..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
  fi

  # Install kitty-scrollback.nvim
  if [[ ! -f "$HOME/.local/share/nvim/lazy/kitty-scrollback.nvim/scripts/mini.sh" ]]; then
    log_info "Installing kitty-scrollback.nvim..."
    sh -c "$(curl -s https://raw.githubusercontent.com/mikesmithgh/kitty-scrollback.nvim/main/scripts/mini.sh)"
  else
    log_info "kitty-scrollback.nvim already installed"
  fi
}

install_optional_tools() {
  log_info "Optional tool installations..."

  # Volta (Node version manager)
  read -p "Install Volta (Node.js version manager)? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if check_command volta; then
      log_info "Volta already installed"
    else
      log_info "Installing Volta..."
      curl https://get.volta.sh | bash
      # Source for current session
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
      log_info "Installing Node.js via Volta..."
      volta install node
      volta install yarn@1.22
    fi
  fi

  # rbenv initialization
  read -p "Install Volta (Node.js version manager)? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    if check_command rbenv; then
      log_info "Adding rbenv init to .zprofile..."
      local rbenv_init='eval "$(rbenv init - --no-rehash zsh)"'
      local rbenv_comment="# Added by rbenv init"
      append_if_missing "$HOME/.zprofile" "$rbenv_comment
$rbenv_init" "rbenv init"
    fi
  fi
}

cleanup_ds_store() {
  log_info "Cleaning .DS_Store files..."
  find "$DOTFILES_DIR" -name '.DS_Store' -type f -delete 2>/dev/null || true
}

main() {
  log_info "Starting dotfiles installation..."
  log_info "Working directory: $DOTFILES_DIR"

  verify_in_dotfiles_dir
  cleanup_ds_store

  # Core installations
  install_homebrew
  install_stow
  setup_homebrew_packages
  setup_zsh_shell
  stow_packages
  install_ohmyzsh
  install_kitty

  # Optional tools
  install_optional_tools

  log_info ""
  log_info "Installation complete!"
  log_info ""
  log_info "Next steps:"
  log_info "  1. Review $HOME/.zprofile for any duplicates"
  log_info "  2. Log out and log back in for shell changes to take effect"
  log_info "  3. Open a new terminal to test configuration"
}

# Run main function
main "$@"
