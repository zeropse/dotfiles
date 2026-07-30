#!/bin/bash

# Homebrew Upgrade Tool - Utilities
# Common utility functions used across the script

if [[ "${_BREW_UTILS_SH_:-}" == "true" ]]; then
    return 0
fi
readonly _BREW_UTILS_SH_="true"

# Source dependencies
SCRIPT_DIR_UTILS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR_UTILS/config.sh"
source "$SCRIPT_DIR_UTILS/logger.sh"

# Trap handler for cleanup on script termination
cleanup() {
    local exit_code=$?
    trap - EXIT INT TERM # Disable traps to prevent double execution
    
    if [[ -n "${TEMP_DIR:-}" && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
    
    if [[ $exit_code -ne 0 ]]; then
        if [[ $exit_code -eq 130 ]]; then
            log_error "Script interrupted by user"
        fi
    fi
    exit $exit_code
}

trap cleanup EXIT INT TERM

# Check if Homebrew is installed and functioning
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_error "Homebrew is not installed. Please install Homebrew first."
        exit $EXIT_HOMEBREW_NOT_FOUND
    fi
    
    local brew_prefix
    brew_prefix=$(brew --prefix 2>/dev/null || echo "")
    if [[ -z "$brew_prefix" || ! -d "$brew_prefix" ]]; then
        log_error "Homebrew installation appears to be corrupted."
        exit $EXIT_HOMEBREW_CORRUPTED
    fi
}

# Run command safely with progress spinner and output logging
run_command() {
    local cmd="$1"
    local description="$2"
    local output_file="$TEMP_DIR/cmd_out_$$.log"
    
    # Run command in background subshell, redirecting output
    bash -c "$cmd" > "$output_file" 2>&1 &
    local pid=$!
    
    spinner "$pid" "$description"
    wait "$pid"
    local status=$?
    
    # Log command output to main logfile
    if [[ -f "$output_file" ]]; then
        cat "$output_file" | strip_ansi >> "$LOG_FILE"
        rm -f "$output_file"
    fi
    
    return $status
}

# Check if a specific package is installed
is_package_installed() {
    local package="$1"
    local type="${2:-formula}" # formula or cask
    
    if [[ "$type" == "cask" ]]; then
        brew list --cask "$package" &>/dev/null
    else
        brew list --formula "$package" &>/dev/null
    fi
}

# Get count of installed formulae or casks
get_package_count() {
    local type="$1" # formula or cask
    local count
    
    if [[ "$type" == "cask" ]]; then
        count=$(brew list --cask 2>/dev/null | wc -l | tr -d ' \n\r')
    else
        count=$(brew list --formula 2>/dev/null | wc -l | tr -d ' \n\r')
    fi
    
    if [[ "$count" =~ ^[0-9]+$ ]]; then
        echo "$count"
    else
        echo "0"
    fi
}

# Count non-empty lines in a file safely
count_file_lines() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local count
        count=$(grep -c '[^[:space:]]' "$file" 2>/dev/null || true)
        count=$(echo "$count" | tr -d ' \n\r')
        if [[ "$count" =~ ^[0-9]+$ ]]; then
            echo "$count"
            return 0
        fi
    fi
    echo "0"
}


# Get Homebrew version
get_homebrew_version() {
    brew --version 2>/dev/null | head -1 || echo "Unknown"
}
