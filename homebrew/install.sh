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

# Show banner
show_banner() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Homebrew Upgrade Tool Installer                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
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
    
    log_success "Prerequisites check passed"
}

# Create installation directory
create_install_dir() {
    log_info "Preparing installation directory..."
    
    # Check if .scripts directory exists
    local scripts_dir="$(dirname "$INSTALL_DIR")"
    if [[ -d "$scripts_dir" ]]; then
        log_info ".scripts directory already exists, using it"
    else
        log_info "Creating .scripts directory"
        mkdir -p "$scripts_dir"
    fi
    
    # Handle existing installation
    if [[ -d "$INSTALL_DIR" ]]; then
        log_warning "Existing installation found. Updating..."
        # Keep the directory but remove old files to ensure clean update
        rm -rf "$INSTALL_DIR"/{brew-upgrade.sh,lib}
    else
        log_info "Creating new installation directory"
    fi
    
    # Ensure installation directory exists
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$(dirname "$SYMLINK_PATH")"
    
    log_success "Installation directory ready: $INSTALL_DIR"
}

# Install from local files (for development/local distribution)
install_local() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
    
    log_info "Installing from local files..."
    
    # Copy main script
    cp "$script_dir/brew-upgrade.sh" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/brew-upgrade.sh"
    
    # Copy lib directory
    if [[ -d "$script_dir/lib" ]]; then
        cp -r "$script_dir/lib" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR"/lib/*.sh
    else
        log_error "Library directory not found at $script_dir/lib"
        exit 1
    fi
    
    log_success "Local files installed successfully"
}

# Install from remote repository (for public distribution)
install_remote() {
    log_info "Downloading from repository..."
    
    local temp_dir
    temp_dir=$(mktemp -d)
    
    # Download and extract
    if curl -sSL "$REPO_URL/archive/main.tar.gz" | tar -xz -C "$temp_dir" --strip-components=1; then
        # Copy files to installation directory
        cp "$temp_dir/homebrew/brew-upgrade.sh" "$INSTALL_DIR/"
        cp -r "$temp_dir/homebrew/lib" "$INSTALL_DIR/"
        
        # Make scripts executable
        chmod +x "$INSTALL_DIR/brew-upgrade.sh"
        chmod +x "$INSTALL_DIR"/lib/*.sh
        
        # Cleanup
        rm -rf "$temp_dir"
        
        log_success "Remote installation completed"
    else
        log_error "Failed to download from repository"
        rm -rf "$temp_dir"
        exit 1
    fi
}

# Create symlink for easy access
create_symlink() {
    log_info "Creating command-line shortcut..."
    
    # Remove existing symlink if it exists
    if [[ -L "$SYMLINK_PATH" ]] || [[ -f "$SYMLINK_PATH" ]]; then
        rm -f "$SYMLINK_PATH"
    fi
    
    # Create new symlink
    ln -s "$INSTALL_DIR/brew-upgrade.sh" "$SYMLINK_PATH"
    
    log_success "Created symlink: $SYMLINK_PATH"
}

# Update PATH if necessary
update_path() {
    local bin_dir="$(dirname "$SYMLINK_PATH")"
    
    # Check if directory is already in PATH
    if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
        log_warning "The directory $bin_dir is not in your PATH"
        echo
        echo "To use the 'brew-upgrade' command from anywhere, add this to your shell profile:"
        echo
        case "$SHELL" in
            */zsh)
                echo "  echo 'export PATH=\"$bin_dir:\$PATH\"' >> ~/.zshrc"
                echo "  source ~/.zshrc"
                ;;
            */bash)
                echo "  echo 'export PATH=\"$bin_dir:\$PATH\"' >> ~/.bashrc"
                echo "  source ~/.bashrc"
                ;;
            *)
                echo "  export PATH=\"$bin_dir:\$PATH\""
                ;;
        esac
        echo
        echo "Or run the tool directly: $SYMLINK_PATH"
    else
        log_success "Command is available in your PATH"
    fi
}

# Show installation summary
show_summary() {
    local action="Installation"
    if [[ -L "$SYMLINK_PATH" ]] && [[ -x "$INSTALL_DIR/brew-upgrade.sh" ]]; then
        action="Update"
    fi
    
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    $action Complete!                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    echo "📁 Installation directory: $INSTALL_DIR"
    echo "🔗 Command shortcut: $SYMLINK_PATH"
    echo
    echo "📚 For more information, run: brew-upgrade --help"
    echo
}

# Uninstall function
uninstall() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Homebrew Upgrade Tool Uninstaller               ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    
    log_info "Uninstalling Homebrew Upgrade Tool..."
    
    local items_removed=0
    
    # Remove installation directory
    if [[ -d "$INSTALL_DIR" ]]; then
        log_info "Removing installation directory: $INSTALL_DIR"
        rm -rf "$INSTALL_DIR"
        log_success "Removed installation directory"
        ((items_removed++))
    else
        log_info "Installation directory not found (already removed)"
    fi
    
    # Remove symlink
    if [[ -L "$SYMLINK_PATH" ]]; then
        log_info "Removing command shortcut: $SYMLINK_PATH"
        rm -f "$SYMLINK_PATH"
        log_success "Removed command shortcut"
        ((items_removed++))
    elif [[ -f "$SYMLINK_PATH" ]]; then
        log_info "Removing file: $SYMLINK_PATH"
        rm -f "$SYMLINK_PATH"
        log_success "Removed file"
        ((items_removed++))
    else
        log_info "Command shortcut not found (already removed)"
    fi
    
    # Check if .scripts directory is empty and offer to remove it
    local scripts_dir="$(dirname "$INSTALL_DIR")"
    if [[ -d "$scripts_dir" ]] && [[ -z "$(ls -A "$scripts_dir" 2>/dev/null)" ]]; then
        log_info "The .scripts directory is empty"
        echo "Would you like to remove the empty .scripts directory? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            rmdir "$scripts_dir"
            log_success "Removed empty .scripts directory"
            ((items_removed++))
        else
            log_info "Keeping .scripts directory"
        fi
    elif [[ -d "$scripts_dir" ]]; then
        log_info "The .scripts directory contains other files, keeping it"
    fi
    
    echo
    if [[ $items_removed -gt 0 ]]; then
        echo "╔══════════════════════════════════════════════════════════════╗"
        echo "║                  Uninstallation Complete!                    ║"
        echo "╚══════════════════════════════════════════════════════════════╝"
        echo
        log_success "Homebrew Upgrade Tool has been completely removed"
        echo "Thank you for using the Homebrew Upgrade Tool! 👋"
    else
        echo "╔══════════════════════════════════════════════════════════════╗"
        echo "║                 Nothing to Uninstall                         ║"
        echo "╚══════════════════════════════════════════════════════════════╝"
        echo
        log_info "No installation found - nothing to remove"
    fi
    
    exit 0
}

# Main installation function
main() {
    # Parse command line arguments
    case "${1:-}" in
        --uninstall)
            uninstall
            ;;
        --help|-h)
            echo "Homebrew Upgrade Tool Installer"
            echo
            echo "Usage: $0 [OPTIONS]"
            echo
            echo "Options:"
            echo "  --uninstall    Remove the installed tool"
            echo "  --help, -h     Show this help message"
            echo
            echo "The installer will:"
            echo "  1. Check prerequisites"
            echo "  2. Create installation directory"
            echo "  3. Install tool files"
            echo "  4. Create command shortcut"
            echo "  5. Provide usage instructions"
            exit 0
            ;;
    esac
    
    show_banner
    check_prerequisites
    create_install_dir
    
    # Try local installation first (for development), fall back to remote
    if [[ -f "$(dirname "${BASH_SOURCE[0]:-$0}")/brew-upgrade.sh" ]]; then
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
