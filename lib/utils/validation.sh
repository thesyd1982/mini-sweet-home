#!/bin/bash
# MSH v3.0 - Input validation and safety checks
# This module provides validation functions for user inputs and system states

# OS Detection
detect_os() {
    if [[ -f /etc/arch-release ]]; then
        echo "arch"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/redhat-release ]]; then
        echo "redhat"
    elif [[ -f /etc/fedora-release ]]; then
        echo "fedora"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Package manager detection
detect_package_manager() {
    local os="$(detect_os)"
    
    case "$os" in
        arch)
            if command -v yay >/dev/null 2>&1; then
                echo "yay"
            elif command -v paru >/dev/null 2>&1; then
                echo "paru"
            elif command -v pacman >/dev/null 2>&1; then
                echo "pacman"
            else
                echo "none"
            fi
            ;;
        debian)
            if command -v apt >/dev/null 2>&1; then
                echo "apt"
            elif command -v apt-get >/dev/null 2>&1; then
                echo "apt-get"
            else
                echo "none"
            fi
            ;;
        redhat|fedora)
            if command -v dnf >/dev/null 2>&1; then
                echo "dnf"
            elif command -v yum >/dev/null 2>&1; then
                echo "yum"
            else
                echo "none"
            fi
            ;;
        macos)
            if command -v brew >/dev/null 2>&1; then
                echo "brew"
            else
                echo "none"
            fi
            ;;
        *)
            echo "none"
            ;;
    esac
}

# Command validation
validate_command() {
    local command="$1"
    local valid_commands=("install" "reinstall" "clean" "uninstall" "test" "status" "aliases" "secrets" "debug-path" "help" "--help" "-h")
    
    for valid_cmd in "${valid_commands[@]}"; do
        if [[ "$command" == "$valid_cmd" ]]; then
            return 0
        fi
    done
    
    return 1
}

# Path validation
validate_path() {
    local path="$1"
    local path_type="${2:-file}"  # file or directory
    
    case "$path_type" in
        file)
            [[ -f "$path" ]]
            ;;
        directory)
            [[ -d "$path" ]]
            ;;
        *)
            return 1
            ;;
    esac
}

# User confirmation validation
validate_yes_no() {
    local response="$1"
    
    case "$response" in
        [Yy]|[Yy][Ee][Ss]|[Nn]|[Nn][Oo]|"")
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Validate MSH environment
validate_msh_environment() {
    local errors=0
    
    # Check essential directories
    if [[ ! -d "$BIN_DIR" ]]; then
        log_error "Missing bin directory: $BIN_DIR"
        errors=$((errors + 1))
    fi
    
    if [[ ! -d "$LIB_DIR" ]]; then
        log_error "Missing lib directory: $LIB_DIR"
        errors=$((errors + 1))
    fi
    
    if [[ ! -d "$CONFIG_DIR" ]]; then
        log_error "Missing config directory: $CONFIG_DIR"
        errors=$((errors + 1))
    fi
    
    # Check essential files
    if [[ ! -f "$BIN_DIR/bulletproof-installer" ]]; then
        log_error "Missing bulletproof installer"
        errors=$((errors + 1))
    fi
    
    return $errors
}