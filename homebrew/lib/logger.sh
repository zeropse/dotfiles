#!/bin/bash

# Homebrew Upgrade Tool - Logging
# Logging utilities with color terminal output and clean file logging

if [[ "${_BREW_LOGGER_SH_:-}" == "true" ]]; then
    return 0
fi
readonly _BREW_LOGGER_SH_="true"

# Source configuration
SCRIPT_DIR_LOGGER="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR_LOGGER/config.sh"

# Helper function to strip ANSI escape codes for clean file writing
strip_ansi() {
    sed $'s/\x1b\\[[0-9;]*[a-zA-Z]//g'
}

# Initialize log file
init_log() {
    mkdir -p "$(dirname "$LOG_FILE")"
    {
        echo "==========================================="
        echo "Homebrew Maintenance Log - $(date)"
        echo "==========================================="
    } > "$LOG_FILE"
}

# Write message to log file safely without ANSI codes
write_to_logfile() {
    echo -e "$1" | strip_ansi >> "$LOG_FILE"
}

# Logging functions
log_info() {
    local msg="$1"
    echo -e "${BLUE}[INFO]${NC} $msg"
    write_to_logfile "[INFO] $msg"
}

log_success() {
    local msg="$1"
    echo -e "${GREEN}[SUCCESS]${NC} $msg"
    write_to_logfile "[SUCCESS] $msg"
}

log_warning() {
    local msg="$1"
    echo -e "${YELLOW}[WARNING]${NC} $msg"
    write_to_logfile "[WARNING] $msg"
}

log_error() {
    local msg="$1"
    echo -e "${RED}[ERROR]${NC} $msg" >&2
    write_to_logfile "[ERROR] $msg"
}

log_step() {
    local step="$1"
    local msg="$2"
    echo -e "\n${BOLD}${BLUE}Step $step:${NC} $msg"
    write_to_logfile "\nStep $step: $msg"
}

log_debug() {
    local msg="$1"
    write_to_logfile "[DEBUG] $msg"
}

# Spinner animation for running background PIDs
spinner() {
    local pid=$1
    local description="$2"
    local delay=0.15
    local i=0

    # If non-interactive, don't show spinner animation
    if [[ ! -t 1 ]]; then
        echo -e "${BLUE}[WAIT]${NC} $description..."
        write_to_logfile "[WAIT] $description..."
        return 0
    fi

    while kill -0 "$pid" 2>/dev/null; do
        local char=${SPINNER_CHARS:$i:1}
        printf "\r${BLUE}[%s]${NC} %s..." "$char" "$description"
        sleep "$delay"
        ((i = (i + 1) % ${#SPINNER_CHARS}))
    done

    printf "\r\033[K" # Clear spinner line
}
