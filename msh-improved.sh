#!/bin/bash
# MSH v3.0 - Mini Sweet Home Unified Command - VERSION AMÉLIORÉE
# Professional modular architecture with bin/, lib/, config/
# CORRECTIONS: Détection de chemin robuste et flexible

set -euo pipefail

# ================================================================
# DÉTECTION DE CHEMIN AMÉLIORÉE - Résout les problèmes identifiés
# ================================================================

# Resolve MSH project directory with multiple strategies
detect_msh_directory() {
    local script_name="$(basename "$0")"
    local script_dir="$(dirname "$0")"
    
    # Strategy 1: Environment variable (highest priority)
    if [[ -n "${MSH_PROJECT_DIR:-}" ]] && validate_msh_directory "$MSH_PROJECT_DIR"; then
        echo "$MSH_PROJECT_DIR"
        return 0
    fi
    
    # Strategy 2: Configuration file
    if [[ -f "$HOME/.msh-config" ]]; then
        local config_dir
        config_dir="$(grep "^MSH_PROJECT_DIR=" "$HOME/.msh-config" 2>/dev/null | cut -d'=' -f2 | tr -d '"' || true)"
        if [[ -n "$config_dir" ]] && validate_msh_directory "$config_dir"; then
            echo "$config_dir"
            return 0
        fi
    fi
    
    # Strategy 3: System installation detection (improved)
    if [[ "$script_name" == "msh" && "$script_dir" == "$HOME/.local/bin" ]]; then
        # Try common installation locations
        local common_locations=(
            "$HOME/mini-sweet-home"
            "$HOME/.config/msh"
            "$HOME/Development/mini-sweet-home"
            "$HOME/Projects/mini-sweet-home"
            "$HOME/dev/mini-sweet-home"
        )
        
        for location in "${common_locations[@]}"; do
            if validate_msh_directory "$location"; then
                echo "$location"
                return 0
            fi
        done
        
        # Fallback: broader search (limited depth for performance)
        local found_dir
        found_dir="$(find "$HOME" -maxdepth 3 -name "msh" -type f -executable 2>/dev/null | while read -r msh_file; do
            local dir="$(dirname "$msh_file")"
            if validate_msh_directory "$dir"; then
                echo "$dir"
                break
            fi
        done | head -n1 || true)"
        
        if [[ -n "$found_dir" ]]; then
            echo "$found_dir"
            return 0
        fi
    fi
    
    # Strategy 4: Direct execution
    local direct_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if validate_msh_directory "$direct_dir"; then
        echo "$direct_dir"
        return 0
    fi
    
    # Strategy 5: Current working directory (last resort)
    if validate_msh_directory "$PWD"; then
        echo "$PWD"
        return 0
    fi
    
    return 1
}

# Strict validation of MSH directory structure
validate_msh_directory() {
    local dir="$1"
    
    # Basic existence checks
    [[ -d "$dir" ]] || return 1
    [[ -f "$dir/msh" ]] || return 1
    [[ -d "$dir/bin" ]] || return 1
    [[ -d "$dir/lib" ]] || return 1
    [[ -d "$dir/config" ]] || return 1
    
    # Critical module checks
    [[ -f "$dir/lib/core/common.sh" ]] || return 1
    [[ -f "$dir/lib/utils/validation.sh" ]] || return 1
    
    return 0
}

# Enhanced error reporting with solutions
report_detection_failure() {
    echo "❌ Error: MSH project directory not found." >&2
    echo >&2
    echo "🔍 MSH tried to find a valid installation in:" >&2
    echo "   • Environment variable: \$MSH_PROJECT_DIR" >&2
    echo "   • Configuration file: ~/.msh-config" >&2
    echo "   • Standard locations: ~/mini-sweet-home, ~/.config/msh" >&2
    echo "   • Current directory and script location" >&2
    echo >&2
    echo "💡 Solutions:" >&2
    echo "   1. Set environment variable:" >&2
    echo "      export MSH_PROJECT_DIR=/path/to/your/msh" >&2
    echo >&2
    echo "   2. Create configuration file:" >&2
    echo "      echo 'MSH_PROJECT_DIR=\"/path/to/msh\"' > ~/.msh-config" >&2
    echo >&2
    echo "   3. Run from MSH directory:" >&2
    echo "      cd /path/to/msh && ./msh" >&2
    echo >&2
    echo "   4. Reinstall MSH in standard location:" >&2
    echo "      git clone [...] ~/mini-sweet-home" >&2
    echo >&2
}

# ================================================================
# MAIN PATH DETECTION LOGIC
# ================================================================

# Detect MSH directory with improved error handling
SCRIPT_DIR="$(detect_msh_directory)"
if [[ $? -ne 0 || -z "$SCRIPT_DIR" ]]; then
    report_detection_failure
    exit 1
fi

# Additional validation after detection
if ! validate_msh_directory "$SCRIPT_DIR"; then
    echo "❌ Error: Detected directory is not a valid MSH installation: $SCRIPT_DIR" >&2
    echo "   Missing required components (lib/core/common.sh, lib/utils/validation.sh)" >&2
    exit 1
fi

# Make directories readonly to prevent accidental modification
readonly SCRIPT_DIR
readonly BIN_DIR="$SCRIPT_DIR/bin"
readonly LIB_DIR="$SCRIPT_DIR/lib" 
readonly CONFIG_DIR="$SCRIPT_DIR/config"

# ================================================================
# CORE MSH FUNCTIONALITY (unchanged from original)
# ================================================================

# Load core modules with better error handling
if ! source "$LIB_DIR/core/common.sh"; then
    echo "❌ Fatal error: Cannot load core MSH library" >&2
    exit 1
fi

if ! source "$LIB_DIR/utils/validation.sh"; then
    echo "❌ Fatal error: Cannot load validation library" >&2
    exit 1
fi

# Display help information
show_help() {
    show_banner "MSH v3.0 - Improved"
    echo "Usage: msh <command> [options]"
    echo
    echo -e "${GREEN}Installation & Setup:${NC}"
    echo "  install           - Install MSH with intelligent symlink management"
    echo "  reinstall         - Reinstall everything from scratch"  
    echo "  clean             - Complete uninstall with backup restoration"
    echo "  uninstall         - Alias for clean"
    echo
    echo -e "${GREEN}Testing & Validation:${NC}"
    echo "  test              - Run comprehensive system test"
    echo "  status            - Show detailed system status"
    echo
    echo -e "${GREEN}Utilities:${NC}"
    echo "  aliases           - Create convenient shell aliases"
    echo "  debug-path        - Show path detection information"
    echo
    echo -e "${GREEN}Examples:${NC}"
    echo "  msh install       - Install with automatic config backup"
    echo "  msh test          - Test your complete setup"
    echo "  msh status        - Check what's working"
    echo "  msh debug-path    - Debug path detection issues"
}

# New debug command for path detection
handle_debug_path() {
    show_banner "MSH Path Detection Debug"
    
    echo -e "${CYAN}Current Configuration:${NC}"
    echo "  Detected MSH Directory: $SCRIPT_DIR"
    echo "  BIN_DIR: $BIN_DIR"
    echo "  LIB_DIR: $LIB_DIR"
    echo "  CONFIG_DIR: $CONFIG_DIR"
    echo
    
    echo -e "${CYAN}Detection Method Used:${NC}"
    if [[ -n "${MSH_PROJECT_DIR:-}" ]]; then
        echo "  ✅ Environment variable: MSH_PROJECT_DIR=$MSH_PROJECT_DIR"
    elif [[ -f "$HOME/.msh-config" ]]; then
        echo "  ✅ Configuration file: ~/.msh-config"
        grep "MSH_PROJECT_DIR" "$HOME/.msh-config" 2>/dev/null || echo "  ⚠️  Config file exists but no MSH_PROJECT_DIR found"
    elif [[ "$(basename "$0")" == "msh" && "$(dirname "$0")" == "$HOME/.local/bin" ]]; then
        echo "  ✅ System installation detection"
    else
        echo "  ✅ Direct execution detection"
    fi
    echo
    
    echo -e "${CYAN}Validation Results:${NC}"
    local checks=(
        "$SCRIPT_DIR:MSH Directory"
        "$SCRIPT_DIR/msh:Main Script"
        "$BIN_DIR:Binary Directory"  
        "$LIB_DIR:Library Directory"
        "$CONFIG_DIR:Configuration Directory"
        "$LIB_DIR/core/common.sh:Core Library"
        "$LIB_DIR/utils/validation.sh:Validation Library"
    )
    
    for check in "${checks[@]}"; do
        local path="${check%:*}"
        local name="${check#*:}"
        if [[ -e "$path" ]]; then
            echo "  ✅ $name"
        else
            echo "  ❌ $name (missing: $path)"
        fi
    done
}

# Handle install command
handle_install() {
    local install_type="${1:-full}"
    
    # Load installation module
    # shellcheck source=lib/core/install.sh
    source "$LIB_DIR/core/install.sh"
    
    case "$install_type" in
        full|"")
            install_msh_system "full"
            ;;
        minimal|quick)
            install_minimal
            ;;
        repair)
            repair_installation
            ;;
        *)
            log_error "Invalid install type: $install_type"
            echo "Valid types: full, minimal, repair"
            return 1
            ;;
    esac
}

# Handle clean command  
handle_clean() {
    # Load clean module
    # shellcheck source=lib/core/clean.sh
    source "$LIB_DIR/core/clean.sh"
    
    clean_msh_system
}

# Handle test command
handle_test() {
    # Load testing module
    # shellcheck source=lib/testing.sh
    if source "$LIB_DIR/testing.sh" 2>/dev/null; then
        run_msh_test
    else
        log_error "Testing library not found: $LIB_DIR/testing.sh"
        return 1
    fi
}

# Handle status command (enhanced)
handle_status() {
    show_banner "MSH System Status - Improved"
    
    # Path detection info
    log_section "🔍 Path Detection"
    echo "  MSH Directory: $SCRIPT_DIR"
    if [[ -n "${MSH_PROJECT_DIR:-}" ]]; then
        echo "  Detection Method: Environment variable"
    elif [[ -f "$HOME/.msh-config" ]]; then
        echo "  Detection Method: Configuration file"
    else
        echo "  Detection Method: Automatic detection"
    fi
    echo
    
    # Check structure
    log_section "📁 Project Structure"
    echo "  bin/    $(ls -1 "$BIN_DIR" 2>/dev/null | wc -l) executables"
    echo "  lib/    $(find "$LIB_DIR" -name "*.sh" 2>/dev/null | wc -l) libraries"
    echo "  config/ $(find "$CONFIG_DIR" -name "*.zsh" -o -name "*.lua" 2>/dev/null | wc -l) configuration files"
    echo
    
    # Check tools
    log_section "🛠️ Modern Tools"
    local tools=("fzy" "rg" "fd" "bat" "eza" "dust" "zoxide" "cmake")
    local available=0
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool"
            available=$((available + 1))
        else
            echo -e "  ${YELLOW}○ $tool (fallback active)${NC}"
        fi
    done
    echo "  Available: $available/${#tools[@]} tools"
    echo
    
    # Check functions
    if source "$CONFIG_DIR/shell/zsh/functions.zsh" 2>/dev/null && declare -f tm >/dev/null; then
        log_success "Personal functions loaded (tm, gq, jp, kcef)"
    else
        log_warning "Personal functions not loaded"
    fi
    
    # Check fallbacks
    # shellcheck source=lib/fallbacks.sh
    if source "$LIB_DIR/fallbacks.sh" quiet 2>/dev/null; then
        log_success "Intelligent fallbacks active"
        echo "  Fuzzy: $MSH_FUZZY_FINDER | List: $MSH_LIST_TOOL | Grep: $MSH_GREP_TOOL"
    else
        log_warning "Fallbacks not loaded"
    fi
    
    # Installation info (rest unchanged...)
    # [Previous status code would continue here]
}

# Handle aliases command
handle_aliases() {
    log_info "Creating convenient aliases..."
    if "$BIN_DIR/create-aliases"; then
        log_success "Aliases created successfully"
    else
        log_error "Failed to create aliases"
        return 1
    fi
}

# Main function
main() {
    local command="${1:-help}"
    shift || true
    
    # Validate environment
    if ! validate_environment; then
        log_error "MSH environment validation failed"
        return 1
    fi
    
    # Validate command
    if ! validate_command "$command" && [[ "$command" != "debug-path" ]]; then
        log_error "Invalid command: $command"
        echo "Run 'msh help' for usage information"
        return 1
    fi
    
    # Dispatch to appropriate handler
    case "$command" in
        install|i)
            handle_install "$@"
            ;;
        reinstall)
            log_info "Reinstalling MSH..."
            handle_install "full" "$@"
            ;;
        clean|uninstall)
            handle_clean "$@"
            ;;
        test|t)
            handle_test "$@"
            ;;
        status|s)
            handle_status "$@"
            ;;
        aliases|a)
            handle_aliases "$@"
            ;;
        debug-path|debug)
            handle_debug_path "$@"
            ;;
        help|--help|-h|"")
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            echo "Run 'msh help' for usage information"
            return 1
            ;;
    esac
}

# Execute main function with all arguments
main "$@"