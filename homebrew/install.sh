#!/bin/bash

# Homebrew Upgrade Tool Installer
# This script installs the modular Homebrew upgrade tool to your system

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/lib/common.sh"

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
    
    # Try local installation first (for development), fall back to remote
    if [[ -f "$SCRIPT_DIR/brew-upgrade.sh" ]]; then
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
