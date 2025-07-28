#!/bin/bash

# Common functions and configuration for Homebrew Upgrade Tool scripts

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
