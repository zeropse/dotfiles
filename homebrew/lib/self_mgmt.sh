#!/bin/bash

# Homebrew Upgrade Tool - Self Management
# Implementation of --update and --uninstall commands

if [[ "${_BREW_SELF_MGMT_SH_:-}" == "true" ]]; then
    return 0
fi
readonly _BREW_SELF_MGMT_SH_="true"

# Source dependencies
SCRIPT_DIR_MGMT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR_MGMT/config.sh"
source "$SCRIPT_DIR_MGMT/logger.sh"
source "$SCRIPT_DIR_MGMT/utils.sh"

# Update the Homebrew Upgrade Tool to the latest version
update_self() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Homebrew Upgrade Tool Updater                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    
    local install_dir="$SCRIPT_DIR"
    local symlink_path="$(dirname "$SCRIPT_DIR")/brew-upgrade"
    
    log_info "Updating Homebrew Upgrade Tool..."
    log_info "Installation directory: $install_dir"
    log_info "Command shortcut: $symlink_path"
    echo
    
    if [[ -t 0 ]]; then
        echo -n "Do you want to continue with update? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Update cancelled by user."
            exit 0
        fi
    fi
    
    local download_dir
    download_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'brew-update')
    
    log_info "Downloading latest version from repository..."
    if curl -sSL "https://github.com/zeropse/dotfiles/archive/main.tar.gz" | tar -xz -C "$download_dir" --strip-components=1; then
        log_success "Downloaded latest version."
    else
        log_error "Failed to download update from repository."
        rm -rf "$download_dir"
        exit 1
    fi
    
    local backup_dir="${install_dir}.backup.$(date +%Y%m%d%H%M%S)"
    log_info "Creating backup at: $backup_dir"
    cp -r "$install_dir" "$backup_dir"
    
    if [[ -f "$download_dir/homebrew/brew-upgrade.sh" && -d "$download_dir/homebrew/lib" ]]; then
        cp "$download_dir/homebrew/brew-upgrade.sh" "$install_dir/"
        chmod +x "$install_dir/brew-upgrade.sh"
        
        cp -r "$download_dir/homebrew/lib/"* "$install_dir/lib/"
        chmod +x "$install_dir"/lib/*.sh
        log_success "Updated all script files and libraries."
    else
        log_error "Updated files missing from downloaded archive."
        rm -rf "$download_dir"
        exit 1
    fi
    
    # Re-verify symlink
    mkdir -p "$(dirname "$symlink_path")"
    rm -f "$symlink_path"
    ln -s "$install_dir/brew-upgrade.sh" "$symlink_path"
    
    rm -rf "$download_dir"
    
    echo
    log_success "Homebrew Upgrade Tool successfully updated!"
    exit 0
}

# Uninstall the Homebrew Upgrade Tool
uninstall_self() {
    echo
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Homebrew Upgrade Tool Uninstaller               ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
    
    local install_dir="$SCRIPT_DIR"
    local symlink_path="$(dirname "$SCRIPT_DIR")/brew-upgrade"
    local scripts_dir="$(dirname "$install_dir")"
    
    log_warning "This will remove the Homebrew Upgrade Tool from your system."
    log_info "Installation directory: $install_dir"
    log_info "Command shortcut: $symlink_path"
    log_info "Log file: $LOG_FILE"
    echo
    
    if [[ -t 0 ]]; then
        echo -n "Are you sure you want to uninstall? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Uninstallation cancelled."
            exit 0
        fi
    fi
    
    echo
    log_info "Removing command shortcut..."
    rm -f "$symlink_path"
    
    if [[ -f "$LOG_FILE" ]]; then
        log_info "Removing log file..."
        rm -f "$LOG_FILE"
    fi
    
    log_info "Removing backups..."
    find "$scripts_dir" -maxdepth 1 -name "homebrew-upgrade.backup.*" -exec rm -rf {} + 2>/dev/null || true
    
    log_info "Removing installation directory..."
    (sleep 1 && rm -rf "$install_dir") &
    
    echo
    log_success "Uninstallation completed successfully."
    exit 0
}
