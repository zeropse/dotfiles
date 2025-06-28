#!/bin/bash

# Homebrew Upgrade - Maintenance Steps
# Individual maintenance step functions

# Source dependencies
source "$(dirname "${BASH_SOURCE[0]}")/config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/logger.sh"
source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Step 1: Initial cleanup
step_initial_cleanup() {
    log_step "1" "Performing initial cleanup"
    
    log_info "Cleaning up old versions, cache, and temporary files..."
    if run_command "brew cleanup -s" "Initial cleanup"; then
        log_success "Initial cleanup completed!"
        return 0
    else
        log_warning "Initial cleanup encountered issues but continuing..."
        return 1
    fi
}

# Step 2: System Health Check
step_doctor() {
    log_step "2" "Running system health check (brew doctor)"
    
    if run_command "brew doctor" "Checking system health"; then
        log_success "System is healthy!"
        return 0
    else
        if [[ "$FORCE_DOCTOR" == "true" ]]; then
            log_warning "System health issues detected, but continuing due to --force-doctor"
            return 0
        else
            log_error "System health issues detected. Use --force-doctor to continue anyway."
            log_info "Run 'brew doctor' manually to see specific issues."
            exit $EXIT_DOCTOR_FAILED
        fi
    fi
}

# Step 3: Update Homebrew
step_update_homebrew() {
    log_step "3" "Updating Homebrew itself"
    
    if run_command "brew update" "Updating Homebrew"; then
        log_success "Homebrew updated successfully!"
        return 0
    else
        log_error "Failed to update Homebrew"
        exit $EXIT_UPDATE_FAILED
    fi
}

# Step 4: Check what's outdated
step_check_outdated() {
    log_step "4" "Analyzing outdated packages"
    
    local outdated_formulae outdated_casks
    
    # Check outdated formulae
    if outdated_formulae=$(brew outdated --formula 2>/dev/null); then
        if [[ -n "$outdated_formulae" ]]; then
            local count
            count=$(echo "$outdated_formulae" | wc -l | tr -d ' ')
            log_info "Found $count outdated formulae:"
            echo "$outdated_formulae" | while read -r formula; do
                [[ -n "$formula" ]] && log_info "  • $formula"
            done
        else
            log_success "All formulae are up to date!"
        fi
    fi
    
    # Check outdated casks
    if [[ "$SKIP_CASKS" != "true" ]]; then
        if outdated_casks=$(brew outdated --cask 2>/dev/null); then
            if [[ -n "$outdated_casks" ]]; then
                local count
                count=$(echo "$outdated_casks" | wc -l | tr -d ' ')
                log_info "Found $count outdated casks:"
                echo "$outdated_casks" | while read -r cask; do
                    [[ -n "$cask" ]] && log_info "  • $cask"
                done
            else
                log_success "All casks are up to date!"
            fi
        fi
    else
        log_info "Skipping cask analysis (--skip-casks enabled)"
    fi
}

# Step 5: Upgrade formulae
step_upgrade_formulae() {
    log_step "5" "Upgrading formulae"
    
    local outdated_count
    outdated_count=$(brew outdated --formula 2>/dev/null | wc -l | tr -d ' ')
    
    if [[ "$outdated_count" -eq 0 ]]; then
        log_success "No formulae need upgrading!"
        return 0
    fi
    
    log_info "Upgrading $outdated_count formulae..."
    
    if run_command "brew upgrade" "Upgrading formulae"; then
        log_success "Formulae upgraded successfully!"
        return 0
    else
        log_error "Failed to upgrade formulae"
        exit $EXIT_UPGRADE_FAILED
    fi
}

# Step 6: Upgrade casks with better error handling
step_upgrade_casks() {
    log_step "6" "Upgrading casks"
    
    local outdated_casks
    outdated_casks=$(brew outdated --cask 2>/dev/null || true)
    
    if [[ -z "$outdated_casks" ]]; then
        log_success "No casks need upgrading!"
        return 0
    fi
    
    log_info "Found casks to upgrade:"
    echo "$outdated_casks" | while read -r cask; do
        [[ -n "$cask" ]] && log_info "  • $cask"
    done
    
    # Upgrade casks one by one for better error handling
    local failed_casks=()
    local success_count=0
    local total_count=0
    
    while read -r cask; do
        [[ -z "$cask" ]] && continue
        ((total_count++))
        
        log_info "Upgrading cask: $cask"
        if run_command "brew upgrade --cask '$cask'" "Upgrading $cask"; then
            log_success "Successfully upgraded: $cask"
            ((success_count++))
        else
            log_warning "Failed to upgrade: $cask (will continue with others)"
            failed_casks+=("$cask")
        fi
    done <<< "$outdated_casks"
    
    # Report results
    if [[ ${#failed_casks[@]} -gt 0 ]]; then
        log_warning "Cask upgrade summary: $success_count/$total_count successful"
        log_warning "Failed casks:"
        for cask in "${failed_casks[@]}"; do
            log_warning "  • $cask"
        done
    else
        log_success "All $total_count casks upgraded successfully!"
    fi
}

# Step 7: Check dependencies
step_check_dependencies() {
    log_step "7" "Checking for missing dependencies"
    
    if run_command "brew missing" "Checking dependencies"; then
        log_success "All dependencies are satisfied!"
        return 0
    else
        log_warning "Some dependencies may be missing"
        log_info "Run 'brew missing' manually for details"
        return 1
    fi
}

# Step 8: Remove unused dependencies
step_autoremove() {
    log_step "8" "Removing unused dependencies"
    
    if run_command "brew autoremove" "Removing unused dependencies"; then
        log_success "Unused dependencies removed!"
        return 0
    else
        log_warning "Could not remove some unused dependencies"
        return 1
    fi
}

# Step 9: Final cleanup
step_final_cleanup() {
    log_step "9" "Performing final cleanup"
    
    if run_command "brew cleanup -s" "Final cleanup"; then
        log_success "Final cleanup completed!"
        return 0
    else
        log_warning "Final cleanup encountered issues"
        return 1
    fi
}

# Step 11: Final health check
step_final_doctor() {
    log_step "10" "Final system health check"
    
    if run_command "brew doctor" "Final health check"; then
        log_success "System is healthy after maintenance!"
        return 0
    else
        log_warning "Some issues remain after maintenance"
        log_info "Check the output above or run 'brew doctor' manually"
        return 1
    fi
}
