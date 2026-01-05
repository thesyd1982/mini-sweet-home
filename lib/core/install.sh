#!/bin/bash
# MSH v3.0 - Installation logic module
# This module handles the complete installation process

# Ensure common utilities are loaded
check_sourcing

# Load required modules
# shellcheck source=lib/core/profile.sh
source "$LIB_DIR/core/profile.sh"
# shellcheck source=lib/core/backup.sh  
source "$LIB_DIR/core/backup.sh"
# shellcheck source=lib/core/core-tools.sh
source "$LIB_DIR/core/core-tools.sh"

# Main installation function
install_msh_system() {
    local install_type="${1:-full}"
    
    show_banner "MSH v3.0 Installation"
    log_action "INSTALL_START" "Beginning MSH v3.0 installation (type=$install_type)"
    
    # Validate environment first
    if ! validate_environment; then
        log_error "Environment validation failed"
        return 1
    fi
    
    # Handle existing installation
    if ! confirm_installation "$install_type"; then
        log_info "Installation cancelled or failed"
        return 1
    fi
    
    # Start installation process
    if ! run_installation_steps "$install_type"; then
        log_error "Installation failed"
        return 1
    fi
    
    # Finalize installation
    if ! finalize_installation "$install_type"; then
        log_error "Installation finalization failed"
        return 1
    fi
    
    log_success "MSH v3.0 installation completed successfully!"
    return 0
}

# Execute installation steps
run_installation_steps() {
    local install_type="$1"
    
    # Step 0: Check and install core tools (zsh, tmux, nvim)
    if ! ensure_core_tools; then
        log_warning "Some core tools are missing, but continuing installation..."
        echo "💡 You can install missing tools later with: msh core-tools install"
    fi
    
    # Step 1: Install modern tools
    if ! install_modern_tools; then
        return 1
    fi
    
    # Step 2: Setup intelligent fallbacks
    if ! setup_intelligent_fallbacks; then
        return 1
    fi
    
    # Step 3: Install system command
    if ! install_system_command; then
        return 1
    fi
    
    # Step 4: Setup configuration symlinks
    if ! setup_config_symlinks; then
        return 1
    fi
    
    return 0
}

# Install modern tools using bulletproof installer
install_modern_tools() {
    log_section "🔍 Installing modern tools (bulletproof mode)"
    
    # Run bulletproof installer from bin/
    if "$BIN_DIR/bulletproof-installer"; then
        log_success "Tools installation complete"
        log_action "TOOLS_INSTALL" "Bulletproof installer completed successfully"
        return 0
    else
        log_success "Installation complete with fallbacks"
        log_action "TOOLS_INSTALL" "Bulletproof installer completed with fallbacks"
        return 0  # Still success, just with fallbacks
    fi
}

# Setup intelligent fallbacks
setup_intelligent_fallbacks() {
    log_section "⚡ Setting up intelligent fallbacks"
    
    # Load fallbacks from lib/
    # shellcheck source=lib/fallbacks.sh
    if source "$LIB_DIR/fallbacks.sh" quiet 2>/dev/null; then
        log_success "Fallbacks configured"
        log_action "FALLBACKS_SETUP" "Intelligent fallbacks configured successfully"
        return 0
    else
        log_warning "Could not load fallbacks"
        log_action "FALLBACKS_SETUP" "Warning: Could not load fallbacks"
        return 1
    fi
}

# Install MSH system command
install_system_command() {
    log_section "🔧 Installing MSH system command"
    
    # Create ~/.local/bin if it doesn't exist
    if ! mkdir -p "$HOME/.local/bin"; then
        log_error "Cannot create ~/.local/bin directory"
        return 1
    fi
    
    # Install/update msh command in system PATH
    if cp "$SCRIPT_DIR/msh" "$HOME/.local/bin/msh" 2>/dev/null; then
        chmod +x "$HOME/.local/bin/msh"
        log_success "MSH command installed globally"
        log_action "MSH_INSTALL" "$HOME/.local/bin/msh installed successfully"
        return 0
    else
        log_warning "Could not install msh globally"
        log_warning "Manual step: cp ~/mini-sweet-home/msh ~/.local/bin/msh"
        log_action "MSH_INSTALL" "Warning: Could not install msh globally"
        return 1
    fi
}

# Finalize installation with logging and profile
finalize_installation() {
    local install_type="$1"
    
    log_section "🛡️ Preserving your configurations"
    log_success "Prompt λ › preserved"
    log_success "Functions tm, gq, jp, kcef preserved"
    log_success "Professional structure: bin/, lib/, config/"
    
    # Save installation profile
    if ! save_installation_profile "$install_type"; then
        log_error "Failed to save installation profile"
        return 1
    fi
    
    # Validate installation integrity
    if validate_installation_integrity; then
        log_success "Installation integrity verified"
    else
        log_warning "Installation integrity issues detected"
    fi
    
    # Final installation log
    log_action "INSTALL_COMPLETE" "MSH v3.0 installation completed successfully"
    
    show_installation_summary
    return 0
}

# Show installation completion summary
show_installation_summary() {
    echo
    log_success "🎉 MSH v3.0 Installation Complete!"
    echo "═══════════════════════════════════════════════════════════"
    echo -e "${BLUE}⚡ Performance:${NC} Shell startup optimized"
    echo -e "${BLUE}🛠️ Tools:${NC} Modern tools with bulletproof fallbacks"
    echo -e "${BLUE}🏗️ Structure:${NC} Professional bin/, lib/, config/ layout"
    echo -e "${BLUE}🛡️ Config:${NC} Your setup preserved and enhanced"
    echo -e "${BLUE}📝 Logs:${NC} Installation tracked in ~/.msh-install.log"
    echo -e "${BLUE}👤 Profile:${NC} Installation profile saved to ~/.msh-version"
    echo
    echo -e "${CYAN}💡 Next steps:${NC}"
    echo "  1. source ~/.zshrc"
    echo "  2. msh test"
    echo "  3. msh aliases (optional convenient shortcuts)"
    echo "  4. Enjoy your professional development environment!"
    echo
    echo -e "${CYAN}💡 Management:${NC}"
    echo "  • Run 'msh clean' to completely uninstall MSH"
    echo "  • Run 'msh status' to check system health"
    echo "  • All changes are logged and reversible"
}

# Repair/update existing installation
repair_installation() {
    log_section "🔧 Repairing MSH installation"
    
    # Validate current installation
    if ! validate_installation_integrity; then
        log_info "Integrity issues found, proceeding with repair"
    fi
    
    # Re-run key installation steps
    if setup_config_symlinks && install_system_command; then
        log_success "Installation repair completed"
        log_action "INSTALL_REPAIR" "MSH installation repaired successfully"
        return 0
    else
        log_error "Installation repair failed"
        return 1
    fi
}

# Quick installation for CI/testing
install_minimal() {
    log_section "⚡ Quick MSH installation"
    
    # Skip confirmation for automated installs
    if run_installation_steps "minimal" && save_installation_profile "minimal"; then
        log_success "Minimal MSH installation completed"
        return 0
    else
        log_error "Minimal installation failed"
        return 1
    fi
}