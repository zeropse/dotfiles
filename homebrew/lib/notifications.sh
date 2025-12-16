#!/bin/bash

# Homebrew Upgrade - Notifications
# System notifications integration

# Source configuration
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"

# Send system notification
send_notification() {
    local title="$1"
    local message="$2"
    local sound="${3:-default}"
    
    # Only run on macOS
    if [[ "$(uname)" == "Darwin" ]]; then
        osascript -e "display notification \"$message\" with title \"$title\" sound name \"$sound\"" 2>/dev/null || true
    fi
}

# Notify success
notify_success() {
    local message="$1"
    send_notification "Homebrew Upgrade" "$message" "Hero"
}

# Notify error
notify_error() {
    local message="${1:-Unknown error occurred}"
    send_notification "Homebrew Upgrade Failed" "$message" "Basso"
}
