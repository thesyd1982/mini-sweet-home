#!/bin/bash
# MSH v3.0 - User profile and installation state management
# This module manages installation detection, profile saving/loading

# Ensure common utilities are loaded
check_sourcing

readonly MSH_PROFILE_FILE="$HOME/.msh-version"
readonly MSH_BACKUP_INDEX="$HOME/.msh-install.log.backups"

# Detect if MSH is already installed
detect_existing_installation() {
    local installation_detected=0
    
    log_info "Checking for existing MSH installation..."
    
    # Check for profile file
    if [[ -f "$MSH_PROFILE_FILE" ]]; then
        log_info "Found MSH profile file: $MSH_PROFILE_FILE"
        installation_detected=1
    fi
    
    # Check for MSH symlinks
    local msh_symlinks=()
    local configs=("$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.gitconfig")
    
    for config in "${configs[@]}"; do
        if [[ -L "$config" ]] && [[ "$(readlink "$config")" =~ mini-sweet-home ]]; then
            msh_symlinks+=("$config")
        fi
    done
    
    if [[ ${#msh_symlinks[@]} -gt 0 ]]; then
        log_info "Found ${#msh_symlinks[@]} MSH symlinks: ${msh_symlinks[*]}"
        installation_detected=1
    fi
    
    # Check for system MSH command
    if [[ -f "$HOME/.local/bin/msh" ]]; then
        log_info "Found MSH system command: $HOME/.local/bin/msh"
        installation_detected=1
    fi
    
    # Check for backup index
    if [[ -f "$MSH_BACKUP_INDEX" ]]; then
        log_info "Found backup index: $MSH_BACKUP_INDEX"
        installation_detected=1
    fi
    
    # Convert detection flag to proper return code (0 = success)
    if [[ $installation_detected -eq 1 ]]; then
        return 0  # Installation detected (success)
    else
        return 1  # No installation detected (failure)
    fi
}

# Get current installation profile
get_installation_profile() {
    if [[ ! -f "$MSH_PROFILE_FILE" ]]; then
        echo "none"
        return 1
    fi
    
    # Source profile file safely
    if source "$MSH_PROFILE_FILE" 2>/dev/null; then
        echo "MSH_VERSION: ${MSH_INSTALLED_VERSION:-unknown}"
        echo "INSTALL_DATE: ${MSH_INSTALL_DATE:-unknown}"
        echo "INSTALL_TYPE: ${MSH_INSTALL_TYPE:-unknown}"
        return 0
    else
        echo "corrupted"
        return 1
    fi
}

# Save installation profile after successful installation
save_installation_profile() {
    local install_type="${1:-full}"
    
    log_info "Saving installation profile..."
    
    # Create profile file with installation metadata
    cat > "$MSH_PROFILE_FILE" << EOF
# MSH Installation Profile
# Generated on $(date)
MSH_INSTALLED_VERSION="$MSH_VERSION"
MSH_INSTALL_DATE="$(date -Iseconds)"
MSH_INSTALL_TYPE="$install_type"
MSH_SCRIPT_DIR="$SCRIPT_DIR"
MSH_INSTALL_USER="$USER"
MSH_INSTALL_HOST="$HOSTNAME"

# Installation components
MSH_SYSTEM_COMMAND="$HOME/.local/bin/msh"
MSH_LOG_FILE="$MSH_LOG_FILE"
MSH_BACKUP_INDEX="$MSH_BACKUP_INDEX"

# Symlinks created (will be populated during installation)
MSH_CREATED_SYMLINKS=""
EOF
    
    if [[ -f "$MSH_PROFILE_FILE" ]]; then
        log_success "Installation profile saved to $MSH_PROFILE_FILE"
        log_action "PROFILE_SAVED" "$MSH_PROFILE_FILE created with type=$install_type"
        return 0
    else
        log_error "Failed to save installation profile"
        return 1
    fi
}

# Update profile with symlink information
update_profile_symlinks() {
    local created_symlinks=("$@")
    
    if [[ ! -f "$MSH_PROFILE_FILE" ]]; then
        log_warning "Profile file not found, cannot update symlinks"
        return 1
    fi
    
    # Create symlinks list
    local symlinks_str
    if [[ ${#created_symlinks[@]} -gt 0 ]]; then
        symlinks_str=$(IFS=','; echo "${created_symlinks[*]}")
    else
        symlinks_str=""
    fi
    
    # Update the profile file
    sed -i "s|MSH_CREATED_SYMLINKS=.*|MSH_CREATED_SYMLINKS=\"$symlinks_str\"|" "$MSH_PROFILE_FILE"
    
    log_action "PROFILE_UPDATED" "Added ${#created_symlinks[@]} symlinks to profile"
}

# Remove installation profile (used during clean)
remove_installation_profile() {
    if [[ -f "$MSH_PROFILE_FILE" ]]; then
        if rm "$MSH_PROFILE_FILE" 2>/dev/null; then
            log_success "Removed installation profile: $MSH_PROFILE_FILE"
            log_action "PROFILE_REMOVED" "$MSH_PROFILE_FILE deleted"
            return 0
        else
            log_error "Failed to remove installation profile"
            return 1
        fi
    else
        log_info "No installation profile found to remove"
        return 0
    fi
}

# Validate installation integrity
validate_installation_integrity() {
    if [[ ! -f "$MSH_PROFILE_FILE" ]]; then
        log_warning "No installation profile found"
        return 1
    fi
    
    # Source profile
    source "$MSH_PROFILE_FILE" 2>/dev/null || {
        log_error "Cannot read installation profile"
        return 1
    }
    
    local issues=0
    
    # Check system command
    if [[ -n "${MSH_SYSTEM_COMMAND:-}" ]]; then
        if [[ ! -f "$MSH_SYSTEM_COMMAND" ]]; then
            log_warning "MSH system command missing: $MSH_SYSTEM_COMMAND"
            issues=$((issues + 1))
        elif [[ ! -x "$MSH_SYSTEM_COMMAND" ]]; then
            log_warning "MSH system command not executable: $MSH_SYSTEM_COMMAND"
            issues=$((issues + 1))
        else
            # Test if system command can run basic operation
            if ! "$MSH_SYSTEM_COMMAND" --help >/dev/null 2>&1; then
                log_warning "MSH system command cannot execute properly"
                issues=$((issues + 1))
            fi
        fi
    fi
    
    # Check symlinks
    if [[ -n "${MSH_CREATED_SYMLINKS:-}" ]]; then
        IFS=',' read -ra symlinks <<< "$MSH_CREATED_SYMLINKS"
        for symlink in "${symlinks[@]}"; do
            if [[ ! -L "$symlink" ]]; then
                log_warning "MSH symlink missing: $symlink"
                issues=$((issues + 1))
            fi
        done
    fi
    
    if [[ $issues -eq 0 ]]; then
        log_success "Installation integrity validated"
        return 0
    else
        log_warning "Found $issues integrity issues"
        return 1
    fi
}

# Handle installation confirmation
confirm_installation() {
    local install_type="$1"
    
    if detect_existing_installation; then
        echo
        log_warning "Existing MSH installation detected!"
        
        # Show current profile
        echo -e "${BLUE}Current installation:${NC}"
        get_installation_profile | while read -r line; do
            echo "  $line"
        done
        echo
        
        echo -e "${YELLOW}Choose installation mode:${NC}"
        echo "  1) Update/Repair current installation"
        echo "  2) Complete reinstallation (with backup)"
        echo "  3) Cancel installation"
        echo
        echo -n "Your choice [1-3]: "
        read -r choice
        
        case "$choice" in
            1)
                log_info "Selected: Update/Repair installation"
                return 0  # Continue with installation
                ;;
            2)
                log_info "Selected: Complete reinstallation"
                # Clean existing installation first
                if source "$LIB_DIR/core/clean.sh" && clean_msh_silently; then
                    log_success "Previous installation cleaned"
                    return 0
                else
                    log_error "Failed to clean previous installation"
                    return 1
                fi
                ;;
            3|"")
                log_info "Installation cancelled by user"
                return 1
                ;;
            *)
                log_error "Invalid choice: $choice"
                return 1
                ;;
        esac
    else
        log_success "No existing installation found, proceeding with fresh install"
        return 0
    fi
}