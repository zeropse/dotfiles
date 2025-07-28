#!/bin/bash

# Homebrew Upgrade Tool Installer
# This script installs the modular Homebrew upgrade tool to your system

set -euo pipefail

# Configuration
readonly TOOL_NAME="brew-upgrade"
readonly REPO_URL="https://github.com/zeropse/dotfiles" 
readonly INSTALL_DIR="$HOME/.scripts/homebrew-upgrade"
readonly SYMLINK_PATH="$HOME/.scripts/brew-upgrade"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1" >&2
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew is not installed. Please install Homebrew first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
    # Check if required tools are available
    local required_tools=("curl" "tar" "mkdir")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            log_error "Required tool '$tool' is not installed"
            exit 1
        fi
    done
    
    log_success "All prerequisites satisfied"
}

# Create installation directory
create_install_dir() {
    log_info "Creating installation directory..."
    
    # Create the .scripts directory if it doesn't exist
    mkdir -p "$(dirname "$INSTALL_DIR")"
    
    # Create the specific tool directory
    mkdir -p "$INSTALL_DIR"
    
    log_success "Installation directory created: $INSTALL_DIR"
}

# Install from remote repository
install_remote() {
    log_info "Downloading from repository..."
    
    # Create temporary directory
    local temp_dir
    temp_dir=$(mktemp -d)
    
    # Download and extract
    if curl -sSL "$REPO_URL/archive/main.tar.gz" | tar -xz -C "$temp_dir" --strip-components=1; then
        log_success "Downloaded latest version"
    else
        log_error "Failed to download from repository"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # Copy files to installation directory
    if [[ -f "$temp_dir/homebrew/brew-upgrade.sh" ]]; then
        cp "$temp_dir/homebrew/brew-upgrade.sh" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/brew-upgrade.sh"
        log_success "Installed main script"
    else
        log_error "Main script not found in download"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    if [[ -d "$temp_dir/homebrew/lib" ]]; then
        cp -r "$temp_dir/homebrew/lib" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR"/lib/*.sh
        log_success "Installed library modules"
    else
        log_error "Library directory not found in download"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # Cleanup
    rm -rf "$temp_dir"
}

# Install from local files (for development)
install_local() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    log_info "Installing from local files..."
    
    # Copy main script
    if [[ -f "$script_dir/brew-upgrade.sh" ]]; then
        cp "$script_dir/brew-upgrade.sh" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/brew-upgrade.sh"
        log_success "Installed main script"
    else
        log_error "Main script not found in local directory"
        exit 1
    fi
    
    # Copy lib directory
    if [[ -d "$script_dir/lib" ]]; then
        cp -r "$script_dir/lib" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR"/lib/*.sh
        log_success "Installed library modules"
    else
        log_error "Library directory not found in local directory"
        exit 1
    fi
}

# Create symlink for easy access
create_symlink() {
    log_info "Creating command shortcut..."
    
    # Remove existing symlink if it exists
    [[ -L "$SYMLINK_PATH" ]] && rm -f "$SYMLINK_PATH"
    
    # Create symlink
    ln -s "$INSTALL_DIR/brew-upgrade.sh" "$SYMLINK_PATH"
    
    log_success "Command shortcut created: $SYMLINK_PATH"
}

# Update PATH if needed
update_path() {
    local scripts_dir="$(dirname "$SYMLINK_PATH")"
    
    # Check if .scripts is in PATH
    if [[ ":$PATH:" != *":$scripts_dir:"* ]]; then
        log_info "Adding $scripts_dir to PATH..."
        
        # Determine which shell config file to update
        local shell_config=""
        if [[ "$SHELL" == *"zsh"* ]]; then
            shell_config="$HOME/.zshrc"
        elif [[ "$SHELL" == *"bash"* ]]; then
            shell_config="$HOME/.bashrc"
        fi
        
        if [[ -n "$shell_config" ]]; then
            echo "" >> "$shell_config"
            echo "# Add .scripts to PATH for Homebrew Upgrade Tool" >> "$shell_config"
            echo "export PATH=\"$scripts_dir:\$PATH\"" >> "$shell_config"
            log_success "Added to PATH in $shell_config"
            log_warning "Please restart your terminal or run: source $shell_config"
        else
            log_warning "Could not determine shell config file. Please add $scripts_dir to your PATH manually."
        fi
    else
        log_success "PATH already configured"
    fi
}

# Show banner
show_banner() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Homebrew Upgrade Tool Installer                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
}

# Show installation summary
show_summary() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Installation Complete!                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    echo "📁 Installation directory: $INSTALL_DIR"
    echo "🔗 Command shortcut: $SYMLINK_PATH"
    echo
    echo "📚 For more information, run: brew-upgrade --help"
    echo
}

# Confirmation prompt
confirm_installation() {
    echo
    echo "This will install the Homebrew Upgrade Tool with the following actions:"
    echo
    echo "  1. ✓ Check prerequisites (Homebrew, curl, tar, mkdir)"
    echo "  2. ✓ Create installation directory: $INSTALL_DIR"
    echo "  3. ✓ Install tool files (brew-upgrade.sh and lib/)"
    echo "  4. ✓ Create command shortcut: $SYMLINK_PATH"
    echo "  5. ✓ Configure PATH if needed"
    echo
    
    if [[ -d "$INSTALL_DIR" ]]; then
        log_warning "Existing installation found - this will update it"
    fi
    
    echo -n "Do you want to continue? (y/N): "
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo
        log_info "Installation cancelled by user"
        echo "To install later, run: ./install.sh"
        exit 0
    fi
    
    echo
    log_success "Installation confirmed, proceeding..."
}

# Main installation function
main() {
    # Parse command line arguments
    case "${1:-}" in
        --help|-h)
            echo "Homebrew Upgrade Tool Installer"
            echo
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  --help, -h     Show this help message"
            echo
            echo "The installer will:"
            echo "  1. Check prerequisites"
            echo "  2. Create installation directory"
            echo "  3. Install tool files"
            echo "  4. Create command shortcut"
            echo "  5. Provide usage instructions"
            echo
            echo "Related commands:"
            echo "  brew-upgrade --update    Update the tool after installation"
            echo "  brew-upgrade --uninstall Remove the tool after installation"
            exit 0
            ;;
    esac
    
    show_banner
    confirm_installation
    check_prerequisites
    create_install_dir
    
    # Check if we're running from a local development directory
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ -f "$script_dir/brew-upgrade.sh" ]]; then
        install_local
    else
        install_remote
    fi
    
    create_symlink
    update_path
    show_summary
}

# Run main function
main "$@"
