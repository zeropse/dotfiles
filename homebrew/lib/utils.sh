#!/bin/bash

# Homebrew Mega Upgrade - Utilities
# Common utility functions used across the script

# Source configuration
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

# Cleanup function for trap
cleanup() {
    local exit_code=$?
    [[ -d "$TEMP_DIR" ]] && rm -rf "$TEMP_DIR"
    if [[ $exit_code -ne 0 ]]; then
        log_error "Script exited with error code $exit_code"
    fi
    exit $exit_code
}

# Set trap for cleanup
trap cleanup EXIT INT TERM

# Function to check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew is not installed. Please install it first."
        exit $EXIT_HOMEBREW_NOT_FOUND
    fi
    
    # Check if Homebrew is properly configured
    if [[ ! -d "$(brew --prefix)" ]]; then
        log_error "Homebrew installation appears to be corrupted."
        exit $EXIT_HOMEBREW_CORRUPTED
    fi
}

# Function to run command
run_command() {
    local cmd="$1"
    local description="$2"
    
    eval "$cmd" &
    local pid=$!
    spinner $pid "$description"
    wait $pid
    return $?
}

# Function to check if a package is installed
is_package_installed() {
    local package="$1"
    local type="${2:-formula}" # formula or cask
    
    if [[ "$type" == "cask" ]]; then
        brew list --cask "$package" &>/dev/null
    else
        brew list --formula "$package" &>/dev/null
    fi
}

# Function to get package count
get_package_count() {
    local type="$1" # formula or cask
    local count
    
    if [[ "$type" == "cask" ]]; then
        count=$(brew list --cask 2>/dev/null | wc -l | tr -d ' \n\r')
    else
        count=$(brew list --formula 2>/dev/null | wc -l | tr -d ' \n\r')
    fi
    
    # Ensure we return a valid number
    if [[ "$count" =~ ^[0-9]+$ ]]; then
        echo "$count"
    else
        echo "0"
    fi
}

# Function to get Homebrew version
get_homebrew_version() {
    brew --version | head -1
}

# Function to update the Homebrew Upgrade Tool
update_self() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Homebrew Upgrade Tool Updater                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    
    # Define paths based on script location
    local install_dir="$SCRIPT_DIR"
    local symlink_path="$(dirname "$SCRIPT_DIR")/brew-upgrade"
    
    echo "🔄 This will update the Homebrew Upgrade Tool to the latest version"
    echo "📁 Installation directory: $install_dir"
    echo "🔗 Command shortcut: $symlink_path"
    echo
    echo "The updater will:"
    echo "  1. ✓ Download latest version from repository"
    echo "  2. ✓ Update tool files (brew-upgrade.sh and lib/)"
    echo "  3. ✓ Preserve your existing configuration"
    echo "  4. ✓ Ensure command shortcut still works"
    echo
    echo "Do you want to continue? (y/N)"
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Update cancelled"
        exit 0
    fi
    
    echo
    echo "🔄 Updating Homebrew Upgrade Tool..."
    
    # Create temporary directory for download
    local temp_dir
    temp_dir=$(mktemp -d)
    
    # Download and extract latest version
    echo "ℹ️  Downloading latest version from repository..."
    if curl -sSL "https://github.com/zeropse/dotfiles/archive/main.tar.gz" | tar -xz -C "$temp_dir" --strip-components=1; then
        echo "✅ Downloaded latest version"
    else
        echo "❌ Failed to download from repository"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # Backup current installation
    local backup_dir="${install_dir}.backup.$(date +%d-%m-%Y)"
    echo "ℹ️  Creating backup: $backup_dir"
    cp -r "$install_dir" "$backup_dir"
    echo "✅ Created backup"
    
    # Update files
    echo "ℹ️  Updating tool files..."
    
    # Update main script
    if [[ -f "$temp_dir/homebrew/brew-upgrade.sh" ]]; then
        cp "$temp_dir/homebrew/brew-upgrade.sh" "$install_dir/"
        chmod +x "$install_dir/brew-upgrade.sh"
        echo "✅ Updated main script"
    else
        echo "❌ Main script not found in download"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # Update lib directory
    if [[ -d "$temp_dir/homebrew/lib" ]]; then
        rm -rf "$install_dir/lib"
        cp -r "$temp_dir/homebrew/lib" "$install_dir/"
        chmod +x "$install_dir"/lib/*.sh
        echo "✅ Updated library modules"
    else
        echo "❌ Library directory not found in download"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    # Verify symlink still works
    if [[ -L "$symlink_path" ]]; then
        if [[ -x "$install_dir/brew-upgrade.sh" ]]; then
            echo "✅ Command shortcut verified"
        else
            echo "⚠️  Recreating command shortcut..."
            rm -f "$symlink_path"
            ln -s "$install_dir/brew-upgrade.sh" "$symlink_path"
            echo "✅ Recreated command shortcut"
        fi
    else
        echo "⚠️  Creating missing command shortcut..."
        ln -s "$install_dir/brew-upgrade.sh" "$symlink_path"
        echo "✅ Created command shortcut"
    fi
    
    # Cleanup
    rm -rf "$temp_dir"
    
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                     Update Complete!                         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    echo "✅ Homebrew Upgrade Tool has been updated to the latest version"
    echo "📁 Installation directory: $install_dir"
    echo "🔗 Command shortcut: $symlink_path"
    echo "💾 Backup created at: $backup_dir"
    echo
    echo "📚 For more information, run: brew-upgrade --help"
    echo
    
    exit 0
}

# Function to uninstall the Homebrew Upgrade Tool
uninstall_self() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Homebrew Upgrade Tool Uninstaller               ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    
    # Define paths based on script location
    local install_dir="$SCRIPT_DIR"
    local symlink_path="$(dirname "$SCRIPT_DIR")/brew-upgrade"
    local scripts_dir="$(dirname "$install_dir")"
    
    echo "🗑️  This will remove the Homebrew Upgrade Tool from your system"
    echo "📁 Installation directory: $install_dir"
    echo "🔗 Command shortcut: $symlink_path"
    echo
    echo "Are you sure you want to uninstall? (y/N)"
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ Uninstall cancelled"
        exit 0
    fi
    
    echo
    echo "🧹 Removing Homebrew Upgrade Tool..."
    
    local items_removed=0
    
    # Remove symlink first (so we can still access the script)
    if [[ -L "$symlink_path" ]]; then
        echo "ℹ️  Removing command shortcut: $symlink_path"
        rm -f "$symlink_path"
        echo "✅ Removed command shortcut"
        ((items_removed++))
    elif [[ -f "$symlink_path" ]]; then
        echo "ℹ️  Removing file: $symlink_path"
        rm -f "$symlink_path"
        echo "✅ Removed file"
        ((items_removed++))
    else
        echo "ℹ️  Command shortcut not found (already removed)"
    fi
    
    # Remove installation directory (this will remove the running script!)
    if [[ -d "$install_dir" ]]; then
        echo "ℹ️  Removing installation directory: $install_dir"
        # Use a background process to remove the directory after this script exits
        (sleep 1 && rm -rf "$install_dir") &
        echo "✅ Scheduled installation directory removal"
        ((items_removed++))
    else
        echo "ℹ️  Installation directory not found (already removed)"
    fi
    
    # Check if .scripts directory is empty and offer to remove it
    if [[ -d "$scripts_dir" ]] && [[ "$scripts_dir" == "$HOME/.scripts" ]]; then
        # Count remaining items (excluding the directory we're about to remove)
        local remaining_items
        remaining_items=$(find "$scripts_dir" -mindepth 1 -maxdepth 1 ! -path "$install_dir" 2>/dev/null | wc -l)
        
        if [[ "$remaining_items" -eq 0 ]]; then
            echo "ℹ️  The .scripts directory will be empty after removal"
            echo "Would you like to remove the empty .scripts directory? (y/N)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                # Schedule removal of scripts directory too
                (sleep 2 && rmdir "$scripts_dir" 2>/dev/null) &
                echo "✅ Scheduled empty .scripts directory removal"
                ((items_removed++))
            else
                echo "ℹ️  Keeping .scripts directory"
            fi
        else
            echo "ℹ️  The .scripts directory contains other files, keeping it"
        fi
    fi
    
    echo
    if [[ $items_removed -gt 0 ]]; then
        echo "╔══════════════════════════════════════════════════════════════╗"
        echo "║                  Uninstallation Complete!                    ║"
        echo "╚══════════════════════════════════════════════════════════════╝"
        echo
        echo "✅ Homebrew Upgrade Tool has been removed"
        echo "Thank you for using the Homebrew Upgrade Tool! 👋"
        echo
        echo "💡 To reinstall in the future, run:"
        echo "   curl -sSL https://raw.githubusercontent.com/zeropse/dotfiles/main/homebrew/install.sh | bash"
    else
        echo "╔══════════════════════════════════════════════════════════════╗"
        echo "║                 Nothing to Uninstall                         ║"
        echo "╚══════════════════════════════════════════════════════════════╝"
        echo
        echo "ℹ️  No installation found - nothing to remove"
    fi
    
    exit 0
}
