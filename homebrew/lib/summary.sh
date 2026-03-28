#!/bin/bash

# Homebrew  Upgrade - Summary and Reporting
# Functions for generating summary reports and statistics

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Function to show initial banner
show_banner() {
    echo
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                 Homebrew Upgrade Script                      ║${NC}"           
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    log_info "Starting Homebrew Maintenance at $(date)"
}

# Function to collect system statistics
collect_stats() {
    local stats_file="$TEMP_DIR/stats.txt"
    
    {
        echo "HOMEBREW_VERSION='$(get_homebrew_version)'"
        echo "FORMULAE_COUNT='$(get_package_count formula)'"
        echo "CASKS_COUNT='$(get_package_count cask)'"
        echo "BREW_PREFIX='$(brew --prefix)'"
        echo "START_TIME='$(date +%s)'"
    } > "$stats_file"
    
    echo "$stats_file"
}

# Function to show summary
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
        
        # Calculate duration
        local duration=$((end_time - START_TIME))
        local minutes=$((duration / 60))
        local seconds=$((duration % 60))
        
        log_info "📊 System Summary:"
        log_info "  • Formulae installed: $FORMULAE_COUNT"
        log_info "  • Casks installed: $CASKS_COUNT"
        log_info "  • Homebrew version: $HOMEBREW_VERSION"
        log_info "  • Installation path: $BREW_PREFIX"
        log_info "  • Duration: ${minutes}m ${seconds}s"
        log_info "  • Mode: ✅ FULL MAINTENANCE"
    fi

    echo
    log_info "📝 Log file: $LOG_FILE"
    log_success "Homebrew maintenance completed at $(date)"
}

# Function to show step progress
show_progress() {
    local current_step="$1"
    local total_steps="$2"
    local step_name="$3"
    
    local percentage=$((current_step * 100 / total_steps))
    local bar_length=30
    local filled_length=$((current_step * bar_length / total_steps))
    
    # Create progress bar
    local bar=""
    for ((i=0; i<filled_length; i++)); do
        bar+="█"
    done
    for ((i=filled_length; i<bar_length; i++)); do
        bar+="░"
    done
    
    log_info "Progress: [$bar] $percentage% ($current_step/$total_steps) - $step_name"
}

# Function to show error summary (if any)
show_error_summary() {
    local error_count
    error_count=$(grep -c "ERROR" "$LOG_FILE" 2>/dev/null || echo "0")
    
    # Clean up the error count to ensure it's a single number
    error_count=$(echo "$error_count" | tr -d ' \n\r' | head -1)
    
    # Ensure it's a valid number
    if [[ ! "$error_count" =~ ^[0-9]+$ ]]; then
        error_count=0
    fi
    
    if [[ $error_count -gt 0 ]]; then
        echo
        log_warning "⚠️  $error_count error(s) occurred during maintenance"
        log_info "Check the log file for details: $LOG_FILE"
        log_info "Recent errors:"
        grep "ERROR" "$LOG_FILE" | tail -3 | while read -r line; do
            log_warning "  $line"
        done
    fi
}
