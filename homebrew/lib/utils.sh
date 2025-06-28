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

# Function to run command with dry-run support
run_command() {
    local cmd="$1"
    local description="$2"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would execute: $cmd"
        return 0
    fi
    
    if [[ "$VERBOSE" == "true" ]]; then
        log_info "Executing: $cmd"
    fi
    
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
