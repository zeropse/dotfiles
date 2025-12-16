#!/bin/bash

# Homebrew Mega Upgrade - Configuration
# Central configuration file for all script components

# Prevent multiple sourcing
if [[ "${BREW_UPGRADE_CONFIG_LOADED:-}" == "true" ]]; then
    return 0
fi
readonly BREW_UPGRADE_CONFIG_LOADED="true"

# File paths
readonly LOG_FILE="${HOME}/.brew-maintenance.log"
readonly TEMP_DIR=$(mktemp -d)

# Runtime configuration (can be overridden by environment variables or CLI)

# Configurable options with defaults
DRY_RUN="${DRY_RUN:-false}"
NOTIFICATIONS="${NOTIFICATIONS:-true}"
SKIP_DOCTOR="${SKIP_DOCTOR:-false}"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Spinner characters
readonly SPINNER_CHARS='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_HOMEBREW_NOT_FOUND=1
readonly EXIT_HOMEBREW_CORRUPTED=2
readonly EXIT_DOCTOR_FAILED=3
readonly EXIT_UPDATE_FAILED=4
readonly EXIT_UPGRADE_FAILED=5
readonly EXIT_UNKNOWN_OPTION=127
