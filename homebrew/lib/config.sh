#!/bin/bash

# Homebrew Upgrade Tool - Configuration
# Central configuration file for all script components

if [[ "${_BREW_CONFIG_SH_:-}" == "true" ]]; then
    return 0
fi
readonly _BREW_CONFIG_SH_="true"

# File paths
readonly LOG_FILE="${HOME}/.brew-maintenance.log"

# Create a unique temporary directory for each run if needed
if [[ -z "${TEMP_DIR:-}" ]]; then
    TEMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'brew-upgrade')
    readonly TEMP_DIR
fi

# Colors for TTY output
if [[ -t 1 ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly BOLD='\033[1m'
    readonly NC='\033[0m' # No Color
else
    readonly RED=''
    readonly GREEN=''
    readonly YELLOW=''
    readonly BLUE=''
    readonly BOLD=''
    readonly NC=''
fi

# Spinner frames
readonly SPINNER_CHARS='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_HOMEBREW_NOT_FOUND=1
readonly EXIT_HOMEBREW_CORRUPTED=2
readonly EXIT_DOCTOR_FAILED=3
readonly EXIT_UPDATE_FAILED=4
readonly EXIT_UPGRADE_FAILED=5
readonly EXIT_UNKNOWN_OPTION=127
