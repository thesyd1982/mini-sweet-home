#!/bin/bash

# ==========================================
# 🧪 MINI SWEET HOME - QUICK TEST
# ==========================================

set -euo pipefail

readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly CYAN='\033[0;36m'
readonly RESET='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
log_success() { echo -e "${GREEN}[✓]${RESET} $1"; }
log_warning() { echo -e "${YELLOW}[⚠]${RESET} $1"; }
log_error() { echo -e "${RED}[✗]${RESET} $1"; }
log_header() { echo -e "${CYAN}$1${RESET}"; }

echo -e "${CYAN}🧪 Test rapide Mini Sweet Home Enhanced${RESET}"
echo "========================================="
echo

# Test des scripts
log_info "Vérification des scripts..."

if [[ -f "setup-enhanced" ]]; then
    if [[ -x "setup-enhanced" ]]; then
        log_success "setup-enhanced (exécutable)"
    else
        log_warning "setup-enhanced (non exécutable)"
        chmod +x setup-enhanced
        log_success "setup-enhanced rendu exécutable"
    fi
else
    log_error "setup-enhanced manquant"
fi

if [[ -f "scripts/setup-neovim.sh" ]]; then
    if [[ -x "scripts/setup-neovim.sh" ]]; then
        log_success "scripts/setup-neovim.sh (exécutable)"
    else
        log_warning "scripts/setup-neovim.sh (non exécutable)"
        chmod +x scripts/setup-neovim.sh
        log_success "scripts/setup-neovim.sh rendu exécutable"
    fi
else
    log_error "scripts/setup-neovim.sh manquant"
fi

# Test des configs
log_info "Vérification des configurations..."

local configs=(
    "configs/nvim:Configuration Neovim"
    "configs/shell/zsh:Configuration ZSH"
    "configs/nvim/lazy-lock.json:Lockfile plugins"
)

for config in "${configs[@]}"; do
    local path="${config%:*}"
    local name="${config#*:}"
    
    if [[ -e "$path" ]]; then
        log_success "$name"
    else
        log_error "$name manquant"
    fi
done

# Test du Makefile
log_info "Vérification du Makefile..."

if [[ -f "Makefile" ]]; then
    if grep -q "enhanced:" Makefile; then
        log_success "Makefile avec commande enhanced"
    else
        log_warning "Makefile sans commande enhanced"
    fi
else
    log_error "Makefile manquant"
fi

echo
log_header "🚀 Test terminé !"
echo
echo "Pour installer Mini Sweet Home Enhanced :"
echo -e "  ${CYAN}make enhanced${RESET}    # Installation interactive"
echo -e "  ${CYAN}make minimal${RESET}     # Profil minimal"
echo -e "  ${CYAN}make modern${RESET}      # Profil modern"
echo -e "  ${CYAN}make developer${RESET}   # Profil developer"
echo
