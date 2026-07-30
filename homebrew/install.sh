#!/bin/bash

# Homebrew Upgrade Tool Installer
# Installs the modular Homebrew upgrade tool to ~/.scripts/homebrew-upgrade

set -euo pipefail

# Global Configuration
readonly TOOL_NAME="brew-upgrade"
readonly REPO_URL="https://github.com/zeropse/dotfiles" 
readonly INSTALL_DIR="$HOME/.scripts/homebrew-upgrade"
readonly SYMLINK_PATH="$HOME/.scripts/brew-upgrade"

# Output Formatting
if [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m'
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly NC=''
fi

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1" >&2; }

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew is not installed. Please install Homebrew first:"
        echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi
    
    local required_tools=("curl" "tar" "mkdir")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_error "Required tool '$tool' is missing."
            exit 1
        fi
    done
    
    log_success "All prerequisites satisfied."
}

# Create installation directory structure
create_install_dir() {
    log_info "Creating installation directories..."
    mkdir -p "$(dirname "$INSTALL_DIR")"
    mkdir -p "$INSTALL_DIR"
    log_success "Created directory: $INSTALL_DIR"
}

# Download from GitHub repository
install_remote() {
    log_info "Downloading latest version from repository..."
    
    local temp_dir
    temp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'brew-install')
    
    if curl -sSL "$REPO_URL/archive/main.tar.gz" | tar -xz -C "$temp_dir" --strip-components=1; then
        log_success "Downloaded source files."
    else
        log_error "Failed to download from repository."
        rm -rf "$temp_dir"
        exit 1
    fi
    
    if [[ -f "$temp_dir/homebrew/brew-upgrade.sh" && -d "$temp_dir/homebrew/lib" ]]; then
        cp "$temp_dir/homebrew/brew-upgrade.sh" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/brew-upgrade.sh"
        
        cp -r "$temp_dir/homebrew/lib" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR"/lib/*.sh
        log_success "Installed main script and modules."
    else
        log_error "Missing expected files in download archive."
        rm -rf "$temp_dir"
        exit 1
    fi
    
    rm -rf "$temp_dir"
}

# Install from local files (development mode)
install_local() {
    local script_dir=""
    if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    else
        script_dir="$(pwd)"
    fi
    
    log_info "Installing from local directory: $script_dir"
    
    if [[ -f "$script_dir/brew-upgrade.sh" && -d "$script_dir/lib" ]]; then
        cp "$script_dir/brew-upgrade.sh" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/brew-upgrade.sh"
        
        cp -r "$script_dir/lib" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR"/lib/*.sh
        log_success "Installed main script and modules."
    else
        log_error "Source files not found in local directory."
        exit 1
    fi
}

# Create executable symlink
create_symlink() {
    log_info "Creating command shortcut..."
    rm -f "$SYMLINK_PATH"
    ln -s "$INSTALL_DIR/brew-upgrade.sh" "$SYMLINK_PATH"
    log_success "Created shortcut: $SYMLINK_PATH -> $INSTALL_DIR/brew-upgrade.sh"
}

# Update user PATH environment variable if needed
update_path() {
    local scripts_dir="$(dirname "$SYMLINK_PATH")"
    
    if [[ ":$PATH:" != *":$scripts_dir:"* ]]; then
        log_info "Adding $scripts_dir to PATH..."
        
        local shell_config=""
        if [[ "${SHELL:-}" == *"zsh"* ]]; then
            shell_config="$HOME/.zshrc"
        elif [[ "${SHELL:-}" == *"bash"* ]]; then
            shell_config="$HOME/.bashrc"
        elif [[ "${SHELL:-}" == *"fish"* ]]; then
            shell_config="$HOME/.config/fish/config.fish"
        else
            shell_config="$HOME/.profile"
        fi
        
        if [[ -f "$shell_config" || -w "$HOME" ]]; then
            echo "" >> "$shell_config"
            echo "# Homebrew Upgrade Tool PATH" >> "$shell_config"
            echo "export PATH=\"$scripts_dir:\$PATH\"" >> "$shell_config"
            log_success "Added $scripts_dir to PATH in $shell_config"
            log_warning "Please restart terminal or run: source $shell_config"
        else
            log_warning "Please manually add $scripts_dir to your PATH."
        fi
    else
        log_success "PATH is already configured correctly."
    fi
}

# Header banner
show_banner() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Homebrew Upgrade Tool Installer                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
}

# Installation completion summary
show_summary() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Installation Complete!                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    echo "📁 Installation directory: $INSTALL_DIR"
    echo "🔗 Command shortcut: $SYMLINK_PATH"
    echo
    echo "📚 To start maintenance, run: brew-upgrade"
    echo "📚 For help, run: brew-upgrade --help"
    echo
}

# Confirmation prompt
confirm_installation() {
    local auto_yes="${1:-false}"
    
    echo "This will install the Homebrew Upgrade Tool:"
    echo "  1. ✓ Check prerequisites (Homebrew, curl, tar)"
    echo "  2. ✓ Install script files into: $INSTALL_DIR"
    echo "  3. ✓ Create command shortcut: $SYMLINK_PATH"
    echo "  4. ✓ Configure shell PATH if needed"
    echo
    
    if [[ -d "$INSTALL_DIR" ]]; then
        log_warning "Existing installation found at $INSTALL_DIR (will be updated)"
    fi
    
    if [[ "$auto_yes" == "true" || ! -t 0 ]]; then
        log_info "Proceeding with installation automatically..."
        return 0
    fi
    
    echo -n "Do you want to continue? (y/N): "
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled by user."
        exit 0
    fi
    
    log_success "Installation confirmed."
}

# Main installer execution
main() {
    local auto_yes=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help)
                echo "Homebrew Upgrade Tool Installer"
                echo
                echo "Usage: $0 [OPTIONS]"
                echo
                echo "Options:"
                echo "  --help    Show this help message"
                echo "  -y, --yes Automatic yes to prompts"
                exit 0
                ;;
            -y|--yes)
                auto_yes=true
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
        shift
    done
    
    show_banner
    confirm_installation "$auto_yes"
    check_prerequisites
    create_install_dir
    
    local script_dir=""
    if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    else
        script_dir="$(pwd)"
    fi
    
    if [[ -f "$script_dir/brew-upgrade.sh" ]]; then
        install_local
    else
        install_remote
    fi
    
    create_symlink
    update_path
    show_summary
}

main "$@"
