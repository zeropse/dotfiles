#!/bin/bash

# Homebrew Upgrade Script
# Comprehensive, modular Homebrew maintenance and upgrade tool

set -euo pipefail

# Get actual script directory (resolving symlinks)
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
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/self_mgmt.sh"
source "$SCRIPT_DIR/lib/cli.sh"
source "$SCRIPT_DIR/lib/steps.sh"
source "$SCRIPT_DIR/lib/summary.sh"

# Main execution entrypoint
main() {
    # Parse CLI flags first
    parse_arguments "$@"
    
    # Initialize logging
    init_log
    
    # Show header banner
    show_banner
    
    # Check Homebrew prerequisites
    check_homebrew
    
    # Show configuration log
    validate_and_show_config
    
    # Collect initial system statistics
    local stats_file
    stats_file=$(collect_stats)
    
    # Define maintenance step pipeline
    local -a steps=(
        "step_update_homebrew:Update Homebrew Index"
        "step_doctor:System Health Check"
        "step_check_outdated:Analyze Outdated Packages"
        "step_upgrade_formulae:Upgrade Formulae"
        "step_upgrade_casks:Upgrade Casks"
        "step_check_dependencies:Check Dependencies"
        "step_autoremove:Remove Unused Dependencies"
        "step_final_cleanup:Final Cleanup"
        "step_final_doctor:Final Health Check"
    )
    
    local total_steps=${#steps[@]}
    local current_step=0
    
    # Execute maintenance pipeline
    for step_info in "${steps[@]}"; do
        local step_function="${step_info%%:*}"
        local step_name="${step_info##*:}"
        
        ((current_step++))
        show_progress "$current_step" "$total_steps" "$step_name"
        
        if declare -f "$step_function" > /dev/null; then
            "$step_function"
        else
            log_error "Unknown step function: $step_function"
            exit 1
        fi
    done
    
    # Render final report
    show_summary "$stats_file"
    show_error_summary
}

main "$@"
