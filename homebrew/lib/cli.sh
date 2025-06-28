#!/bin/bash

# Homebrew Upgrade - CLI Parser
# Command line argument parsing and help system

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"

# Function to show usage
show_usage() {
    echo
    echo -e "${BOLD}OPTIONS:${NC}"
    echo "    -d, --dry-run       Show what would be done without executing"
    echo "                        Example: $SCRIPT_NAME --dry-run"
    echo
    echo "    -v, --verbose       Enable verbose output and detailed logging"
    echo "                        Example: $SCRIPT_NAME --verbose"
    echo
    echo "    -h, --help          Show this help message"
    echo "                        Example: $SCRIPT_NAME --help"
    echo
    echo "    --skip-casks        Skip cask upgrades (faster execution)"
    echo "                        Example: $SCRIPT_NAME --skip-casks"
    echo
    echo "    --skip-cleanup      Skip cleanup operations (both initial and final)"
    echo "                        Example: $SCRIPT_NAME --skip-cleanup"
    echo
    echo "    --force-doctor      Continue even if brew doctor fails"
    echo "                        Example: $SCRIPT_NAME --force-doctor"
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            --skip-casks)
                SKIP_CASKS=true
                shift
                ;;
            --skip-cleanup)
                SKIP_CLEANUP=true
                shift
                ;;
            --force-doctor)
                FORCE_DOCTOR=true
                shift
                ;;
            -h|--help)
                show_usage
                exit $EXIT_SUCCESS
                ;;
            *)
                log_error "Unknown option: $1"
                echo
                show_usage
                exit $EXIT_UNKNOWN_OPTION
                ;;
        esac
    done
    
    # Export variables for use in other modules
    export DRY_RUN VERBOSE SKIP_CASKS SKIP_CLEANUP FORCE_DOCTOR
}

# Validate arguments and show configuration
validate_and_show_config() {
    log_debug "Configuration:"
    log_debug "  DRY_RUN=$DRY_RUN"
    log_debug "  VERBOSE=$VERBOSE"
    log_debug "  SKIP_CASKS=$SKIP_CASKS"
    log_debug "  SKIP_CLEANUP=$SKIP_CLEANUP"
    log_debug "  FORCE_DOCTOR=$FORCE_DOCTOR"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_warning "DRY RUN MODE - No changes will be made"
    fi
    
    if [[ "$SKIP_CASKS" == "true" ]]; then
        log_info "Cask upgrades will be skipped"
    fi
    
    if [[ "$SKIP_CLEANUP" == "true" ]]; then
        log_info "Cleanup operations will be skipped"
    fi
    
    if [[ "$FORCE_DOCTOR" == "true" ]]; then
        log_info "Will continue even if brew doctor fails"
    fi
}
