#!/bin/bash
# MSH v3.0 - Backup and symlink management
# This module handles configuration backup, symlink creation and restoration

# Ensure common utilities are loaded
check_sourcing

# Backup existing config file with timestamp
backup_config() {
    local source_path="$1"
    local backup_suffix="msh-backup-$(get_timestamp)"
    
    if [[ -e "$source_path" ]]; then
        local backup_path="${source_path}.${backup_suffix}"
        
        if cp "$source_path" "$backup_path" 2>/dev/null; then
            log_success "Backed up: $(basename "$source_path") → $(basename "$backup_path")"
            log_action "BACKUP" "$source_path → $backup_path"
            
            # Record backup mapping
            echo "$source_path|$backup_path" >> "$MSH_BACKUP_INDEX"
            return 0
        else
            log_error "Could not backup: $source_path"
            return 1
        fi
    fi
    return 0
}

# Create intelligent symlink with backup handling
create_intelligent_symlink() {
    local target_path="$1"
    local link_path="$2" 
    local config_name="$3"
    
    # Validate target exists
    if [[ ! -f "$target_path" ]]; then
        log_error "Target config not found: $target_path"
        return 1
    fi
    
    # If symlink already exists and points to correct target
    if [[ -L "$link_path" ]] && [[ "$(readlink "$link_path")" == "$target_path" ]]; then
        log_success "$config_name symlink already correct"
        return 0
    fi
    
    # If symlink exists but is broken or points elsewhere, remove it
    if [[ -L "$link_path" ]]; then
        rm "$link_path" 2>/dev/null
        log_info "Removed old symlink: $config_name"
        log_action "REMOVE_SYMLINK" "$link_path"
    fi
    
    # If regular file/directory exists, backup it
    if [[ -e "$link_path" ]]; then
        if backup_config "$link_path"; then
            rm "$link_path" 2>/dev/null
        else
            log_error "Failed to backup existing $config_name"
            return 1
        fi
    fi
    
    # Create new symlink
    if ln -sf "$target_path" "$link_path" 2>/dev/null; then
        log_success "Created $config_name symlink"
        log_action "CREATE_SYMLINK" "$link_path → $target_path"
        return 0
    else
        log_error "Failed to create $config_name symlink"
        return 1
    fi
}

# Setup all configuration symlinks intelligently
setup_config_symlinks() {
    log_section "🔗 Setting up intelligent configuration symlinks"
    
    local configs=(
        "$CONFIG_DIR/shell/zsh/zshrc|$HOME/.zshrc|ZSH config"
        "$CONFIG_DIR/tmux/tmux.conf|$HOME/.tmux.conf|Tmux config"
        "$CONFIG_DIR/git/gitconfig|$HOME/.gitconfig|Git config"
    )
    
    local created_symlinks=()
    local successful_count=0
    
    for config in "${configs[@]}"; do
        IFS='|' read -r target_path link_path config_name <<< "$config"
        
        if create_intelligent_symlink "$target_path" "$link_path" "$config_name"; then
            created_symlinks+=("$link_path")
            successful_count=$((successful_count + 1))
        fi
    done
    
    log_success "Created $successful_count/${#configs[@]} configuration symlinks"
    
    # Update profile with created symlinks
    if [[ ${#created_symlinks[@]} -gt 0 ]] && command_exists update_profile_symlinks; then
        update_profile_symlinks "${created_symlinks[@]}"
    fi
    
    return 0
}

# Restore backed up config files
restore_config_backups() {
    if [[ ! -f "$MSH_BACKUP_INDEX" ]]; then
        log_info "No backup index found"
        return 0
    fi
    
    log_section "🔄 Restoring backed up configurations"
    
    local restored_count=0
    local backup_count=0
    
    # Count total backups first
    backup_count=$(grep -v '^#' "$MSH_BACKUP_INDEX" 2>/dev/null | wc -l)
    
    if [[ $backup_count -eq 0 ]]; then
        log_info "No backups found to restore"
        return 0
    fi
    
    log_info "Found $backup_count backup(s) to restore"
    
    # Process each backup mapping
    while IFS='|' read -r source_path backup_path; do
        # Skip comments and empty lines
        [[ "$source_path" =~ ^# ]] && continue
        [[ -z "$source_path" || -z "$backup_path" ]] && continue
        
        if [[ -f "$backup_path" ]]; then
            # Remove current symlink/file
            if [[ -e "$source_path" ]]; then
                rm "$source_path" 2>/dev/null
                log_action "REMOVE_FOR_RESTORE" "$source_path"
            fi
            
            # Restore backup
            if mv "$backup_path" "$source_path" 2>/dev/null; then
                log_success "Restored: $(basename "$source_path")"
                log_action "RESTORE" "$backup_path → $source_path"
                restored_count=$((restored_count + 1))
            else
                log_warning "Could not restore: $source_path"
            fi
        else
            log_warning "Backup not found: $backup_path"
        fi
    done < "$MSH_BACKUP_INDEX"
    
    log_success "Restored $restored_count/$backup_count configuration files"
    
    # Clean up backup index after successful restoration
    if [[ $restored_count -gt 0 ]]; then
        rm "$MSH_BACKUP_INDEX" 2>/dev/null
        log_action "CLEANUP" "Removed backup index after restoration"
    fi
    
    return 0
}

# Remove MSH symlinks (used during clean)
remove_msh_symlinks() {
    log_section "🔗 Removing MSH configuration symlinks"
    
    local configs=(
        "$HOME/.zshrc|ZSH config"
        "$HOME/.tmux.conf|Tmux config"
        "$HOME/.gitconfig|Git config"
    )
    
    local removed_count=0
    
    for config in "${configs[@]}"; do
        IFS='|' read -r link_path config_name <<< "$config"
        
        if [[ -L "$link_path" ]]; then
            # Check if it's an MSH symlink (points to mini-sweet-home)
            if [[ "$(readlink "$link_path")" =~ mini-sweet-home ]]; then
                if rm "$link_path" 2>/dev/null; then
                    log_success "Removed $config_name symlink"
                    log_action "REMOVE_SYMLINK" "$link_path"
                    removed_count=$((removed_count + 1))
                else
                    log_warning "Could not remove $config_name symlink"
                fi
            else
                log_info "$config_name symlink not managed by MSH"
            fi
        elif [[ -e "$link_path" ]]; then
            log_info "$config_name is not a symlink, skipping"
        else
            log_info "No $config_name found"
        fi
    done
    
    log_success "Removed $removed_count MSH symlinks"
    return 0
}

# Validate symlinks integrity
validate_symlinks() {
    local broken_count=0
    local configs=("$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.gitconfig")
    
    log_info "Validating MSH symlinks..."
    
    for config in "${configs[@]}"; do
        if [[ -L "$config" ]]; then
            if [[ -e "$config" ]]; then
                log_success "$(basename "$config") symlink valid"
            else
                log_warning "$(basename "$config") symlink broken"
                broken_count=$((broken_count + 1))
            fi
        fi
    done
    
    if [[ $broken_count -eq 0 ]]; then
        log_success "All symlinks validated successfully"
        return 0
    else
        log_warning "Found $broken_count broken symlinks"
        return 1
    fi
}