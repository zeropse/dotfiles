#!/bin/bash

# Homebrew Upgrade Script

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Get script directory and set global variables
# Resolve symlinks to get the actual script location (cross-platform)
get_script_dir() {
    local source="${BASH_SOURCE[0]:-$0}"
    while [[ -L "$source" ]]; do
        local dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source"
    done
    cd -P "$(dirname "$source")" && pwd
}
readonly SCRIPT_DIR="$(get_script_dir)"
readonly SCRIPT_NAME="$(basename "$0")"

# Source all required modules
source "$SCRIPT_DIR/lib/config.sh"
source "$SCRIPT_DIR/lib/logger.sh"
source "$SCRIPT_DIR/lib/notifications.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/cli.sh"
source "$SCRIPT_DIR/lib/steps.sh"
source "$SCRIPT_DIR/lib/summary.sh"

# Main execution function
main() {
    # Parse command line arguments first (before logging)
    parse_arguments "$@"
    
    # Initialize logging
    init_log
    
    # Show banner and initial information
    show_banner
    
    # Validate Homebrew installation
    check_homebrew
    
    # Validate configuration and show settings
    validate_and_show_config
    
    # Collect initial statistics
    local stats_file
    stats_file=$(collect_stats)
    
    # Define maintenance steps
    local -a steps=()
    
    steps+=(
        "step_initial_cleanup:Initial Cleanup"
        "step_doctor:System Health Check"
        "step_update_homebrew:Update Homebrew"
    )

    steps+=(
        "step_check_outdated:Analyze Outdated Packages"
        "step_upgrade_formulae:Upgrade Formulae"
        "step_upgrade_casks:Upgrade Casks"
        "step_check_dependencies:Check Dependencies"
        "step_autoremove:Remove Unused Dependencies"
        "step_final_cleanup:Final Cleanup"
        "step_final_doctor:Final Health Check"
    )
    
    # Execute maintenance steps
    local total_steps=${#steps[@]}
    local current_step=0
    
    for step_info in "${steps[@]}"; do
        local step_function="${step_info%%:*}"
        local step_name="${step_info##*:}"
        
        ((current_step++))
        show_progress "$current_step" "$total_steps" "$step_name"
        
        # Execute the step function
        if declare -f "$step_function" > /dev/null; then
            "$step_function"
        else
            log_error "Unknown step function: $step_function"
            exit 1
        fi
    done
    
    # Show comprehensive summary
    show_summary "$stats_file"
    show_error_summary
}

# Run the main function with all arguments
main "$@"
