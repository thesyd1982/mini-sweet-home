#!/bin/bash
# MSH v3.0 - Clean/uninstall module
# This module handles complete MSH removal and restoration

# Ensure common utilities are loaded
check_sourcing

# Load required modules
# shellcheck source=lib/core/profile.sh
source "$LIB_DIR/core/profile.sh"
# shellcheck source=lib/core/backup.sh
source "$LIB_DIR/core/backup.sh"

# Main clean function with user confirmation
clean_msh_system() {
    show_banner "MSH v3.0 Clean/Uninstall"
    
    # Check if MSH is installed
    if ! detect_existing_installation; then
        log_info "No MSH installation detected"
        echo -e "${BLUE}ℹ️  MSH does not appear to be installed${NC}"
        echo "Nothing to clean."
        return 0
    fi
    
    # Show what will be cleaned
    show_clean_preview
    
    # Confirm operation
    if ! confirm_clean_operation; then
        log_info "Clean operation cancelled by user"
        echo -e "${BLUE}ℹ️  Clean operation cancelled${NC}"
        return 0
    fi
    
    # Perform clean
    log_action "CLEAN_START" "Beginning MSH v3.0 clean/uninstall"
    
    if execute_clean_steps; then
        log_success "MSH v3.0 clean completed successfully!"
        show_clean_summary
        return 0
    else
        log_error "Clean operation failed"
        return 1
    fi
}

# Silent clean for automated operations (used during reinstall)
clean_msh_silently() {
    log_action "CLEAN_SILENT_START" "Beginning silent MSH clean for reinstall"
    
    if execute_clean_steps; then
        log_success "Silent MSH clean completed"
        return 0
    else
        log_error "Silent clean failed"
        return 1
    fi
}

# Show preview of what will be cleaned
show_clean_preview() {
    echo
    echo -e "${YELLOW}⚠️  This will completely remove MSH and restore your original configurations${NC}"
    echo
    echo -e "${BLUE}The following will be removed/restored:${NC}"
    
    # Check symlinks
    local msh_symlinks=()
    local configs=("$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.gitconfig")
    
    for config in "${configs[@]}"; do
        if [[ -L "$config" ]] && [[ "$(readlink "$config")" =~ mini-sweet-home ]]; then
            msh_symlinks+=("$(basename "$config")")
        fi
    done
    
    if [[ ${#msh_symlinks[@]} -gt 0 ]]; then
        echo "  📎 Remove MSH symlinks: ${msh_symlinks[*]}"
    fi
    
    # Check backups
    if [[ -f "$MSH_BACKUP_INDEX" ]]; then
        local backup_count
        backup_count=$(grep -v '^#' "$MSH_BACKUP_INDEX" 2>/dev/null | wc -l)
        if [[ $backup_count -gt 0 ]]; then
            echo "  🔄 Restore $backup_count original configuration(s)"
        fi
    fi
    
    # Check system command
    if [[ -f "$HOME/.local/bin/msh" ]]; then
        echo "  🗑️  Remove system MSH command"
    fi
    
    # Check installation files
    local install_files=()
    [[ -f "$MSH_PROFILE_FILE" ]] && install_files+=("installation profile")
    [[ -f "$MSH_LOG_FILE" ]] && install_files+=("installation logs")
    
    if [[ ${#install_files[@]} -gt 0 ]]; then
        echo "  🧹 Remove MSH ${install_files[*]}"
    fi
    
    echo
}

# Confirm clean operation
confirm_clean_operation() {
    echo -n "Are you sure you want to continue? [y/N]: "
    read -r response
    
    case "$response" in
        [Yy]|[Yy][Ee][Ss])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Execute all clean steps
execute_clean_steps() {
    local steps_completed=0
    local total_steps=5
    
    # Step 1: Remove MSH symlinks
    if remove_msh_symlinks; then
        steps_completed=$((steps_completed + 1))
    fi
    
    # Step 2: Restore original configs
    if restore_config_backups; then
        steps_completed=$((steps_completed + 1))
    fi
    
    # Step 3: Remove system MSH command
    if remove_system_command; then
        steps_completed=$((steps_completed + 1))
    fi
    
    # Step 4: Clean logs and caches
    if cleanup_logs_and_caches; then
        steps_completed=$((steps_completed + 1))
    fi
    
    # Step 5: Remove installation profile
    if remove_installation_profile; then
        steps_completed=$((steps_completed + 1))
    fi
    
    log_info "Completed $steps_completed/$total_steps clean steps"
    
    if [[ $steps_completed -eq $total_steps ]]; then
        log_action "CLEAN_COMPLETE" "All clean steps completed successfully"
        return 0
    else
        log_action "CLEAN_PARTIAL" "Clean completed with $((total_steps - steps_completed)) failures"
        return 1
    fi
}

# Remove MSH system command
remove_system_command() {
    log_section "🗑️  Removing MSH system command"
    
    if [[ -f "$HOME/.local/bin/msh" ]]; then
        if rm "$HOME/.local/bin/msh" 2>/dev/null; then
            log_success "Removed MSH system command"
            log_action "REMOVE_SYSTEM_CMD" "$HOME/.local/bin/msh removed"
            return 0
        else
            log_warning "Could not remove MSH system command"
            log_warning "Manual removal needed: rm ~/.local/bin/msh"
            return 1
        fi
    else
        log_info "No MSH system command found"
        return 0
    fi
}

# Clean logs and cache files
cleanup_logs_and_caches() {
    log_section "🧹 Cleaning logs and caches"
    
    local cleaned_files=()
    local files_to_clean=(
        "$MSH_LOG_FILE"
        "$MSH_BACKUP_INDEX"
        "$HOME/.msh-install.log.old"
    )
    
    for file in "${files_to_clean[@]}"; do
        if [[ -f "$file" ]]; then
            if rm "$file" 2>/dev/null; then
                cleaned_files+=("$(basename "$file")")
                log_action "CLEANUP" "$file removed"
            else
                log_warning "Could not remove: $file"
            fi
        fi
    done
    
    if [[ ${#cleaned_files[@]} -gt 0 ]]; then
        log_success "Cleaned ${#cleaned_files[@]} log/cache files"
        return 0
    else
        log_info "No log/cache files found to clean"
        return 0
    fi
}

# Show clean completion summary  
show_clean_summary() {
    echo
    echo -e "${GREEN}🎉 MSH v3.0 Clean Complete!${NC}"
    echo "═══════════════════════════════════════════════════════"
    echo -e "${BLUE}✅ MSH symlinks removed${NC}"
    echo -e "${BLUE}✅ Original configurations restored${NC}"
    echo -e "${BLUE}✅ System command removed${NC}"
    echo -e "${BLUE}✅ Installation traces cleaned${NC}"
    echo
    echo -e "${GREEN}Your system has been restored to its pre-MSH state${NC}"
    echo
    echo -e "${CYAN}💡 If you want to reinstall MSH later:${NC}"
    echo "  cd ~/mini-sweet-home && ./msh install"
}

# Validate clean operation completed successfully
validate_clean_completion() {
    local issues=0
    
    # Check for remaining symlinks
    local configs=("$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.gitconfig")
    for config in "${configs[@]}"; do
        if [[ -L "$config" ]] && [[ "$(readlink "$config")" =~ mini-sweet-home ]]; then
            log_warning "MSH symlink still exists: $config"
            issues=$((issues + 1))
        fi
    done
    
    # Check for remaining system command
    if [[ -f "$HOME/.local/bin/msh" ]]; then
        log_warning "MSH system command still exists"
        issues=$((issues + 1))
    fi
    
    # Check for remaining profile
    if [[ -f "$MSH_PROFILE_FILE" ]]; then
        log_warning "MSH profile still exists"
        issues=$((issues + 1))
    fi
    
    if [[ $issues -eq 0 ]]; then
        log_success "Clean validation passed - no MSH traces found"
        return 0
    else
        log_warning "Clean validation found $issues remaining traces"
        return 1
    fi
}