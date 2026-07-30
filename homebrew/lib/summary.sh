#!/bin/bash

# Homebrew Upgrade Tool - Summary and Reporting
# Functions for progress reporting, statistics, and final summary

if [[ "${_BREW_SUMMARY_SH_:-}" == "true" ]]; then
    return 0
fi
readonly _BREW_SUMMARY_SH_="true"

# Source dependencies
SCRIPT_DIR_SUMMARY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR_SUMMARY/config.sh"
source "$SCRIPT_DIR_SUMMARY/logger.sh"
source "$SCRIPT_DIR_SUMMARY/utils.sh"

# Show initial execution banner
show_banner() {
    echo
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                 Homebrew Upgrade Script                      ║${NC}"           
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    log_info "Starting Homebrew Maintenance at $(date)"
}

# Collect initial system statistics
collect_stats() {
    local stats_file="$TEMP_DIR/stats.txt"
    
    {
        echo "HOMEBREW_VERSION='$(get_homebrew_version)'"
        echo "FORMULAE_COUNT='$(get_package_count formula)'"
        echo "CASKS_COUNT='$(get_package_count cask)'"
        echo "BREW_PREFIX='$(brew --prefix 2>/dev/null || echo "Unknown")'"
        echo "START_TIME='$(date +%s)'"
    } > "$stats_file"
    
    echo "$stats_file"
}

# Show progress bar during step execution
show_progress() {
    local current_step="$1"
    local total_steps="$2"
    local step_name="$3"
    
    local percentage=$((current_step * 100 / total_steps))
    local bar_length=30
    local filled_length=$((current_step * bar_length / total_steps))
    
    local bar=""
    for ((i=0; i<filled_length; i++)); do
        bar+="█"
    done
    for ((i=filled_length; i<bar_length; i++)); do
        bar+="░"
    done
    
    log_info "Progress: [$bar] $percentage% ($current_step/$total_steps) - $step_name"
}

# Show summary dashboard
show_summary() {
    local stats_file="$1"
    local end_time
    end_time=$(date +%s)
    
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    MAINTENANCE COMPLETED                     ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    
    if [[ -f "$stats_file" ]]; then
        source "$stats_file"
        
        local duration=$((end_time - START_TIME))
        local minutes=$((duration / 60))
        local seconds=$((duration % 60))
        
        log_info "  • Formulae installed: ${FORMULAE_COUNT:-0}"
        log_info "  • Casks installed: ${CASKS_COUNT:-0}"
        log_info "  • Homebrew version: ${HOMEBREW_VERSION:-Unknown}"
        log_info "  • Installation path: ${BREW_PREFIX:-Unknown}"
        log_info "  • Duration: ${minutes}m ${seconds}s"
    fi

    echo
    log_info "📝 Log file: $LOG_FILE"
    log_success "Homebrew maintenance completed at $(date)"
}

# Show error summary if any errors were logged
show_error_summary() {
    if [[ ! -f "$LOG_FILE" ]]; then
        return 0
    fi

    local error_count
    error_count=$(grep -c "\[ERROR\]" "$LOG_FILE" 2>/dev/null || true)
    error_count=$(echo "$error_count" | tr -d ' \n\r')
    error_count=${error_count:-0}
    
    if [[ $error_count -gt 0 ]]; then
        echo
        log_warning "⚠️  $error_count error(s) occurred during maintenance"
        log_info "Log file details: $LOG_FILE"
        log_info "Recent errors:"
        grep "\[ERROR\]" "$LOG_FILE" | tail -3 | while read -r line; do
            log_warning "  $line"
        done
    fi
}
