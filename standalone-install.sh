#!/bin/bash

# ===============================
# 🏠 MINI SWEET HOME - STANDALONE INSTALLER
# ===============================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Banner
echo -e "${PURPLE}"
cat << "EOF"
🏠 MINI SWEET HOME - STANDALONE INSTALLER
=========================================
Complete Development Environment Setup
EOF
echo -e "${NC}"

# Variables
REPO_URL="https://github.com/thesyd1982/mini-sweet-home.git"
INSTALL_DIR="$HOME/mini-sweet-home"

# ===============================
# 🔍 SYSTEM CHECK
# ===============================

check_requirements() {
    log "Checking system requirements..."
    
    # Check if Git is available
    if ! command -v git >/dev/null 2>&1; then
        warn "Git not found. Installing..."
        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y git curl
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y git curl
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm git curl
        elif command -v brew >/dev/null 2>&1; then
            brew install git curl
        else
            error "Cannot install Git automatically. Please install Git and try again."
            exit 1
        fi
    fi
    
    success "System requirements met"
}

# ===============================
# 📥 REPOSITORY SETUP
# ===============================

setup_repository() {
    log "Setting up Mini Sweet Home repository..."
    
    # Backup existing installation if it exists
    if [[ -d "$INSTALL_DIR" ]]; then
        warn "Existing installation found. Creating backup..."
        mv "$INSTALL_DIR" "${INSTALL_DIR}.backup.$(date +%s)"
    fi
    
    # Clone the repository
    log "Cloning Mini Sweet Home from GitHub..."
    if git clone "$REPO_URL" "$INSTALL_DIR"; then
        success "Repository cloned successfully"
    else
        error "Failed to clone repository. Please check your internet connection."
        exit 1
    fi
    
    # Navigate to install directory
    cd "$INSTALL_DIR"
}

# ===============================
# 🚀 INSTALLATION
# ===============================

run_installation() {
    log "Running Mini Sweet Home installation..."
    
    # Make scripts executable
    chmod +x install
    chmod +x bin/*
    
    # Run the installation
    if make install; then
        success "Mini Sweet Home installed successfully!"
    else
        error "Installation failed. Check the error messages above."
        exit 1
    fi
}

# ===============================
# 🔍 POST-INSTALL VALIDATION
# ===============================

validate_installation() {
    log "Validating installation..."
    
    # Quick validation
    if make quick-check; then
        success "Installation validation passed!"
    else
        warn "Some validation checks failed, but core installation is complete"
    fi
}

# ===============================
# 🎉 COMPLETION MESSAGE
# ===============================

show_completion_message() {
    echo ""
    echo -e "${GREEN}🎉 MINI SWEET HOME INSTALLATION COMPLETE! 🎉${NC}"
    echo ""
    echo -e "${CYAN}🚀 Next steps:${NC}"
    echo "  1. Restart your terminal OR run: exec zsh"
    echo "  2. Test performance: make benchmark"
    echo "  3. Run health check: make health"
    echo ""
    echo -e "${PURPLE}🏠 Welcome to your new cozy coding home! 🏠${NC}"
}

# ===============================
# 🎯 MAIN EXECUTION
# ===============================

main() {
    check_requirements
    setup_repository
    run_installation
    validate_installation
    show_completion_message
    
    # Start ZSH
    echo ""
    echo -e "${GREEN}🚀 Starting ZSH...${NC}"
    exec zsh
}

# Run main function
main "$@"
