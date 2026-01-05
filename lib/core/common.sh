#!/bin/bash
# MSH v3.0 - Common utilities and shared functions
# This module provides standardized logging, colors, and utility functions

set -euo pipefail

# MSH Version and metadata
readonly MSH_VERSION="3.0.0"
readonly MSH_LOG_FILE="$HOME/.msh-install.log"

# Color constants
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly RED='\033[0;31m'
readonly NC='\033[0m'

# Logging functions with standardized format
log_info() {
    local message="$1"
    echo -e "${BLUE}ℹ️  $message${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $message" >> "$MSH_LOG_FILE"
}

log_success() {
    local message="$1"
    echo -e "${GREEN}✅ $message${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $message" >> "$MSH_LOG_FILE"
}

log_warning() {
    local message="$1"
    echo -e "${YELLOW}⚠️  $message${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $message" >> "$MSH_LOG_FILE"
}

log_error() {
    local message="$1"
    echo -e "${RED}❌ $message${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $message" >> "$MSH_LOG_FILE"
}

log_section() {
    local title="$1"
    echo -e "${CYAN}$title${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SECTION: $title" >> "$MSH_LOG_FILE"
}

# Enhanced action logging for operations tracking
log_action() {
    local action="$1"
    local details="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $action: $details" >> "$MSH_LOG_FILE"
}

# Timestamp generation for backups and logs
get_timestamp() {
    date '+%Y%m%d_%H%M%S'
}

# Environment validation
validate_environment() {
    # Use global variables if available, otherwise skip validation
    if [[ -z "${SCRIPT_DIR:-}" ]]; then
        return 0  # Skip validation if not in main script context
    fi
    
    # Check if we're in the right directory
    if [[ ! -f "$SCRIPT_DIR/msh" ]]; then
        log_error "MSH script not found. Please run from MSH directory."
        return 1
    fi
    
    # Check required directories exist if variables are set
    if [[ -n "${BIN_DIR:-}" && -n "${LIB_DIR:-}" && -n "${CONFIG_DIR:-}" ]]; then
        local required_dirs=("$BIN_DIR" "$LIB_DIR" "$CONFIG_DIR")
        for dir in "${required_dirs[@]}"; do
            if [[ ! -d "$dir" ]]; then
                log_error "Required directory missing: $dir"
                return 1
            fi
        done
    fi
    
    return 0
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get script directory (called from main msh)
get_script_directory() {
    cd "$(dirname "${BASH_SOURCE[1]}")" && pwd
}

# Initialize logging
init_logging() {
    # Ensure log file exists and is writable
    touch "$MSH_LOG_FILE" 2>/dev/null || {
        echo -e "${RED}❌ Cannot create log file: $MSH_LOG_FILE${NC}"
        return 1
    }
}

# Display MSH banner
show_banner() {
    local operation="${1:-MSH v3.0}"
    echo -e "${CYAN}🏠 $operation - Mini Sweet Home${NC}"
    echo -e "${CYAN}Professional Development Environment${NC}"
    echo "═══════════════════════════════════════════════════════════"
}

# Error handling wrapper
safe_execute() {
    local description="$1"
    shift
    
    if "$@"; then
        log_success "$description completed"
        return 0
    else
        log_error "$description failed"
        return 1
    fi
}

# Check if MSH is sourced correctly
check_sourcing() {
    if [[ -z "${SCRIPT_DIR:-}" ]]; then
        echo -e "${RED}❌ MSH core modules must be sourced from main msh script${NC}"
        exit 1
    fi
}

# Ensure common module is loaded only once
if [[ -z "${MSH_COMMON_LOADED:-}" ]]; then
    readonly MSH_COMMON_LOADED=1
    init_logging
fi