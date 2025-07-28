#!/bin/bash

# Homebrew Mega Upgrade - Logging
# Logging functions with color support and file output

# Source configuration
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"

# Initialize log file
init_log() {
    echo "===========================================" > "$LOG_FILE"
    echo "Homebrew Maintenance Log - $(date)" >> "$LOG_FILE"
    echo "===========================================" >> "$LOG_FILE"
}

# Logging functions
log_info() {
    local msg="$1"
    echo -e "${BLUE}[INFO]${NC} $msg" | tee -a "$LOG_FILE"
}

log_success() {
    local msg="$1"
    echo -e "${GREEN}[SUCCESS]${NC} $msg" | tee -a "$LOG_FILE"
}

log_warning() {
    local msg="$1"
    echo -e "${YELLOW}[WARNING]${NC} $msg" | tee -a "$LOG_FILE"
}

log_error() {
    local msg="$1"
    echo -e "${RED}[ERROR]${NC} $msg" | tee -a "$LOG_FILE" >&2
}

log_step() {
    local step="$1"
    local msg="$2"
    echo -e "\n${BOLD}${BLUE}Step $step:${NC} $msg" | tee -a "$LOG_FILE"
}

log_debug() {
    local msg="$1"
    echo "[DEBUG] $msg" >> "$LOG_FILE"
}

# Enhanced spinner with step description
spinner() {
    local pid=$1
    local description="$2"
    local delay=0.2
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        local char=${SPINNER_CHARS:$i:1}
        printf "\r${BLUE}[%s]${NC} %s..." "$char" "$description"
        sleep $delay
        ((i = (i + 1) % ${#SPINNER_CHARS}))
    done
    printf "\r${GREEN}[✓]${NC} %s completed\n" "$description"
}
