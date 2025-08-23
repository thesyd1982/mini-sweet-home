#!/bin/bash

# ==========================================
# 🚀 NEOVIM AUTO-SETUP SCRIPT
# ==========================================

set -euo pipefail

# Couleurs
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly RESET='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_success() { echo -e "${GREEN}[✓]${RESET} $1"; }
log_warning() { echo -e "${YELLOW}[⚠]${RESET} $1"; }
log_error() { echo -e "${RED}[✗]${RESET} $1"; }

readonly NVIM_CONFIG_SOURCE="$HOME/mini-sweet-home/configs/nvim"
readonly NVIM_CONFIG_TARGET="$HOME/.config/nvim"
readonly NVIM_DATA_DIR="$HOME/.local/share/nvim"

install_neovim_config() {
    log_info "Setting up Neovim configuration..."
    
    # Create config directory
    mkdir -p "$HOME/.config"
    
    # Backup existing config if it exists
    if [[ -d "$NVIM_CONFIG_TARGET" ]]; then
        local backup_dir="$HOME/.config/nvim.backup-$(date +%Y%m%d-%H%M%S)"
        log_warning "Backing up existing config to: $backup_dir"
        mv "$NVIM_CONFIG_TARGET" "$backup_dir"
    fi
    
    # Copy configuration
    if [[ -d "$NVIM_CONFIG_SOURCE" ]]; then
        cp -r "$NVIM_CONFIG_SOURCE" "$NVIM_CONFIG_TARGET"
        log_success "Neovim configuration copied"
    else
        log_error "Source config not found: $NVIM_CONFIG_SOURCE"
        return 1
    fi
}

install_lazy_nvim() {
    log_info "Installing Lazy.nvim plugin manager..."
    
    local lazy_path="$NVIM_DATA_DIR/lazy/lazy.nvim"
    
    if [[ -d "$lazy_path" ]]; then
        log_warning "Lazy.nvim already exists, updating..."
        cd "$lazy_path" && git pull
    else
        log_info "Cloning Lazy.nvim..."
        git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$lazy_path"
    fi
    
    log_success "Lazy.nvim installed"
}

setup_plugins_auto_install() {
    log_info "Setting up automatic plugin installation..."
    
    # Create a temporary script for headless installation
    local install_script="$HOME/.config/nvim/install_plugins.lua"
    
    cat > "$install_script" << 'EOF'
-- Auto-install script for Neovim plugins
-- This will install all plugins in headless mode

-- Ensure lazy.nvim is loaded
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load configuration
require("config.options")
require("config.lazy")

-- Install plugins and exit
require("lazy").install({ wait = true })

-- Also update if any plugins exist
require("lazy").update({ wait = true })

print("✅ All plugins installed successfully!")
vim.cmd("qall!")
EOF

    log_success "Plugin auto-install script created"
}

install_plugins_headless() {
    log_info "Installing Neovim plugins in headless mode..."
    
    if ! command -v nvim >/dev/null 2>&1; then
        log_error "Neovim not found! Please install Neovim first."
        return 1
    fi
    
    log_info "This may take a few minutes depending on your internet connection..."
    
    # Run neovim in headless mode to install plugins
    if nvim --headless -u "$HOME/.config/nvim/install_plugins.lua" 2>/dev/null; then
        log_success "All plugins installed successfully!"
    else
        log_warning "Plugin installation encountered issues, but config is ready"
        log_info "Plugins will auto-install on first Neovim launch"
    fi
    
    # Clean up the temporary install script
    rm -f "$HOME/.config/nvim/install_plugins.lua"
}

restore_lockfile() {
    log_info "Restoring plugin lockfile for consistent versions..."
    
    local source_lock="$NVIM_CONFIG_SOURCE/lazy-lock.json"
    local target_lock="$NVIM_CONFIG_TARGET/lazy-lock.json"
    
    if [[ -f "$source_lock" ]]; then
        cp "$source_lock" "$target_lock"
        log_success "Plugin lockfile restored"
    else
        log_warning "No lockfile found, plugins will use latest versions"
    fi
}

verify_installation() {
    log_info "Verifying installation..."
    
    # Check if config exists
    if [[ -d "$NVIM_CONFIG_TARGET" ]]; then
        log_success "Configuration directory exists"
    else
        log_error "Configuration directory missing"
        return 1
    fi
    
    # Check if lazy.nvim exists
    if [[ -d "$NVIM_DATA_DIR/lazy/lazy.nvim" ]]; then
        log_success "Lazy.nvim plugin manager installed"
    else
        log_error "Lazy.nvim missing"
        return 1
    fi
    
    # Check if some plugins exist
    local plugins_dir="$NVIM_DATA_DIR/lazy"
    local plugin_count=$(find "$plugins_dir" -maxdepth 1 -type d | wc -l)
    
    if [[ $plugin_count -gt 5 ]]; then
        log_success "Plugins installed ($((plugin_count - 1)) plugins found)"
    else
        log_warning "Few plugins found, may need manual installation"
    fi
    
    log_success "Neovim setup complete!"
}

show_usage() {
    echo "Usage: $0 [--headless|--no-plugins]"
    echo "  --headless     Install plugins in headless mode (recommended)"
    echo "  --no-plugins   Only install config, skip plugin installation"
    echo "  --help         Show this help"
}

main() {
    local install_plugins=true
    local headless_mode=true
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --no-plugins)
                install_plugins=false
                shift
                ;;
            --headless)
                headless_mode=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    echo -e "${BLUE}🚀 Mini Sweet Home - Neovim Auto Setup${RESET}"
    echo "======================================"
    echo
    
    # Step 1: Install configuration
    install_neovim_config
    
    if [[ "$install_plugins" == "true" ]]; then
        # Step 2: Install Lazy.nvim
        install_lazy_nvim
        
        # Step 3: Restore lockfile for consistent versions
        restore_lockfile
        
        # Step 4: Setup auto-install script
        setup_plugins_auto_install
        
        # Step 5: Install plugins
        if [[ "$headless_mode" == "true" ]]; then
            install_plugins_headless
        else
            log_info "Plugins will be installed on first Neovim launch"
        fi
    else
        log_info "Skipping plugin installation as requested"
    fi
    
    # Step 6: Verify installation
    verify_installation
    
    echo
    echo -e "${GREEN}🎉 Neovim setup complete!${RESET}"
    echo
    echo "Next steps:"
    if [[ "$install_plugins" == "true" && "$headless_mode" == "true" ]]; then
        echo "• Launch nvim - everything should be ready!"
    else
        echo "• Launch nvim - plugins will auto-install on first launch"
    fi
    echo "• Run ':Lazy' to manage plugins"
    echo "• Run ':checkhealth' to verify everything works"
    echo
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
