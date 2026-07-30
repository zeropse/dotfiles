#!/bin/bash

# Homebrew Upgrade Tool - Maintenance Steps
# Individual maintenance step implementations

if [[ "${_BREW_STEPS_SH_:-}" == "true" ]]; then
    return 0
fi
readonly _BREW_STEPS_SH_="true"

# Source dependencies
SCRIPT_DIR_STEPS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR_STEPS/config.sh"
source "$SCRIPT_DIR_STEPS/logger.sh"
source "$SCRIPT_DIR_STEPS/utils.sh"

# Step 1: Update Homebrew core and taps
step_update_homebrew() {
    log_step "1" "Updating Homebrew index and taps"
    
    if run_command "brew update" "Updating Homebrew"; then
        log_success "Homebrew index updated successfully!"
        return 0
    else
        log_error "Failed to update Homebrew index"
        exit $EXIT_UPDATE_FAILED
    fi
}

# Step 2: System Health Check
step_doctor() {
    log_step "2" "Running system health check (brew doctor)"
    
    if run_command "brew doctor" "Checking system health"; then
        log_success "System health check passed cleanly!"
        return 0
    else
        log_warning "System health warnings detected; continuing with maintenance."
        log_info "Run 'brew doctor' manually for specific details."
        return 0
    fi
}

# Step 3: Analyze Outdated Packages (and cache result)
step_check_outdated() {
    log_step "3" "Analyzing outdated formulae and casks"
    
    local outdated_formulae_file="$TEMP_DIR/outdated_formulae.txt"
    local outdated_casks_file="$TEMP_DIR/outdated_casks.txt"
    
    brew outdated --formula 2>/dev/null > "$outdated_formulae_file" || true
    brew outdated --cask 2>/dev/null > "$outdated_casks_file" || true
    
    local formulae_count casks_count
    formulae_count=$(count_file_lines "$outdated_formulae_file")
    casks_count=$(count_file_lines "$outdated_casks_file")
    
    if [[ "$formulae_count" -gt 0 ]]; then
        log_info "Found $formulae_count outdated formulae:"
        while read -r formula; do
            [[ -n "$formula" ]] && log_info "  • $formula"
        done < "$outdated_formulae_file"
    else
        log_success "All formulae are up to date!"
    fi
    
    if [[ "$casks_count" -gt 0 ]]; then
        log_info "Found $casks_count outdated casks:"
        while read -r cask; do
            [[ -n "$cask" ]] && log_info "  • $cask"
        done < "$outdated_casks_file"
    else
        log_success "All casks are up to date!"
    fi
}

# Step 4: Upgrade Formulae
step_upgrade_formulae() {
    log_step "4" "Upgrading formulae"
    
    local outdated_formulae_file="$TEMP_DIR/outdated_formulae.txt"
    local formulae_count
    formulae_count=$(count_file_lines "$outdated_formulae_file")
    
    if [[ "$formulae_count" -eq 0 ]]; then
        log_success "No formulae need upgrading."
        return 0
    fi
    
    log_info "Upgrading $formulae_count outdated formulae..."
    
    if run_command "brew upgrade --formula" "Upgrading formulae"; then
        log_success "Formulae upgraded successfully!"
        return 0
    else
        log_error "Failed to upgrade formulae"
        exit $EXIT_UPGRADE_FAILED
    fi
}

# Step 5: Upgrade Casks
step_upgrade_casks() {
    log_step "5" "Upgrading casks"
    
    local outdated_casks_file="$TEMP_DIR/outdated_casks.txt"
    local casks_count
    casks_count=$(count_file_lines "$outdated_casks_file")
    
    if [[ "$casks_count" -eq 0 ]]; then
        log_success "No casks need upgrading."
        return 0
    fi
    
    local failed_casks=()
    local success_count=0
    local total_count=0
    
    while read -r cask; do
        [[ -z "$cask" ]] && continue
        ((total_count++))
        
        log_info "Upgrading cask ($total_count/$casks_count): $cask"
        if run_command "brew upgrade --cask \"$cask\"" "Upgrading cask $cask"; then
            log_success "Successfully upgraded $cask"
            ((success_count++))
        else
            log_warning "Failed to upgrade cask $cask (will continue with others)"
            failed_casks+=("$cask")
        fi
    done < "$outdated_casks_file"
    
    if [[ ${#failed_casks[@]} -gt 0 ]]; then
        log_warning "Cask upgrade results: $success_count/$total_count successful."
        log_warning "Failed casks: ${failed_casks[*]}"
    else
        log_success "All $total_count casks upgraded successfully!"
    fi
}

# Step 6: Check Dependencies
step_check_dependencies() {
    log_step "6" "Checking for broken or missing dependencies"
    
    if run_command "brew missing" "Checking dependencies"; then
        log_success "All package dependencies are satisfied!"
        return 0
    else
        log_warning "Some missing dependencies detected."
        log_info "Run 'brew missing' manually for details."
        return 0
    fi
}

# Step 7: Remove Unused Dependencies
step_autoremove() {
    log_step "7" "Removing unused orphan dependencies"
    
    if run_command "brew autoremove" "Removing unused dependencies"; then
        log_success "Unused dependencies removed!"
        return 0
    else
        log_warning "Could not remove some unused dependencies."
        return 0
    fi
}

# Step 8: Final Cleanup
step_final_cleanup() {
    log_step "8" "Performing final system cleanup"
    
    if run_command "brew cleanup -s" "Cleaning stale caches and old downloads"; then
        log_success "Final cleanup completed successfully!"
        return 0
    else
        log_warning "Final cleanup encountered non-fatal issues."
        return 0
    fi
}

# Step 9: Final Doctor Check
step_final_doctor() {
    log_step "9" "Final health check"
    
    if run_command "brew doctor" "Final health check"; then
        log_success "System is healthy after maintenance!"
        return 0
    else
        log_warning "System health warnings remain after maintenance."
        return 0
    fi
}
