#!/bin/bash
# ===============================
# 🏠 MSH CORE TOOLS MANAGEMENT
# ===============================
# Vérification et installation des outils de base (nvim, tmux, zsh)

# Ensure common utilities are loaded
check_sourcing

# Load OS detection utilities
# shellcheck source=lib/utils/validation.sh
source "$LIB_DIR/utils/validation.sh"

# ===============================
# 📋 CONFIGURATION DES OUTILS DE BASE
# ===============================

# Définition des outils de base requis
declare -A CORE_TOOLS=(
    ["zsh"]="ZSH Shell"
    ["tmux"]="Terminal Multiplexer" 
    ["nvim"]="Neovim Editor"
)

# Packages par OS pour chaque outil
declare -A UBUNTU_PACKAGES=(
    ["zsh"]="zsh"
    ["tmux"]="tmux"
    ["nvim"]="neovim"
)

declare -A ARCH_PACKAGES=(
    ["zsh"]="zsh"
    ["tmux"]="tmux"
    ["nvim"]="neovim"
)

declare -A FEDORA_PACKAGES=(
    ["zsh"]="zsh"
    ["tmux"]="tmux"
    ["nvim"]="neovim"
)

declare -A MACOS_PACKAGES=(
    ["zsh"]="zsh"
    ["tmux"]="tmux"
    ["nvim"]="neovim"
)

# ===============================
# 🔍 FONCTIONS DE VÉRIFICATION
# ===============================

# Vérifier si un outil de base est installé
check_core_tool() {
    local tool="$1"
    
    if command -v "$tool" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Vérifier tous les outils de base
check_all_core_tools() {
    local missing_tools=()
    local total_tools=${#CORE_TOOLS[@]}
    local available_tools=0
    
    echo "🔍 Checking core tools..."
    echo
    
    for tool in "${!CORE_TOOLS[@]}"; do
        local description="${CORE_TOOLS[$tool]}"
        
        if check_core_tool "$tool"; then
            log_success "$description ($tool)"
            available_tools=$((available_tools + 1))
        else
            log_warning "$description ($tool) - Missing"
            missing_tools+=("$tool")
        fi
    done
    
    echo
    echo "📊 Core tools status: $available_tools/$total_tools available"
    
    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        echo
        log_warning "Missing core tools: ${missing_tools[*]}"
        return 1
    else
        log_success "All core tools are installed!"
        return 0
    fi
}

# ===============================
# 📦 FONCTIONS D'INSTALLATION
# ===============================

# Obtenir le nom du package selon l'OS
get_package_name() {
    local tool="$1"
    local os="$2"
    
    case "$os" in
        "ubuntu"|"debian")
            echo "${UBUNTU_PACKAGES[$tool]:-$tool}"
            ;;
        "arch")
            echo "${ARCH_PACKAGES[$tool]:-$tool}"
            ;;
        "fedora"|"rhel"|"centos")
            echo "${FEDORA_PACKAGES[$tool]:-$tool}"
            ;;
        "macos")
            echo "${MACOS_PACKAGES[$tool]:-$tool}"
            ;;
        *)
            echo "$tool"
            ;;
    esac
}

# Installer un outil selon l'OS
install_core_tool() {
    local tool="$1"
    local os="$(detect_os)"
    local package_manager="$(detect_package_manager)"
    local package_name="$(get_package_name "$tool" "$os")"
    
    echo "📦 Installing $tool ($package_name) on $os..."
    
    case "$package_manager" in
        "apt")
            if sudo apt update >/dev/null 2>&1 && sudo apt install -y "$package_name" >/dev/null 2>&1; then
                log_success "$tool installed via apt"
                return 0
            fi
            ;;
        "yay")
            if yay -S --noconfirm "$package_name" >/dev/null 2>&1; then
                log_success "$tool installed via yay"
                return 0
            fi
            ;;
        "paru")
            if paru -S --noconfirm "$package_name" >/dev/null 2>&1; then
                log_success "$tool installed via paru"
                return 0
            fi
            ;;
        "pacman")
            if sudo pacman -S --noconfirm "$package_name" >/dev/null 2>&1; then
                log_success "$tool installed via pacman"
                return 0
            fi
            ;;
        "dnf")
            if sudo dnf install -y "$package_name" >/dev/null 2>&1; then
                log_success "$tool installed via dnf"
                return 0
            fi
            ;;
        "brew")
            if brew install "$package_name" >/dev/null 2>&1; then
                log_success "$tool installed via brew"
                return 0
            fi
            ;;
        *)
            log_error "Unsupported package manager: $package_manager"
            return 1
            ;;
    esac
    
    log_error "Failed to install $tool"
    return 1
}

# ===============================
# 🤖 INSTALLATION INTERACTIVE
# ===============================

# Proposer l'installation des outils manquants
offer_core_tools_installation() {
    local missing_tools=()
    
    # Identifier les outils manquants
    for tool in "${!CORE_TOOLS[@]}"; do
        if ! check_core_tool "$tool"; then
            missing_tools+=("$tool")
        fi
    done
    
    if [[ ${#missing_tools[@]} -eq 0 ]]; then
        return 0
    fi
    
    echo
    log_warning "⚠️  Missing core tools detected!"
    echo
    echo "The following essential tools are not installed:"
    
    for tool in "${missing_tools[@]}"; do
        local description="${CORE_TOOLS[$tool]}"
        echo "  • $tool - $description"
    done
    
    echo
    echo "These tools are required for the full MSH experience:"
    echo "  • zsh: Enhanced shell with MSH native features"
    echo "  • tmux: Terminal multiplexer for session management"
    echo "  • nvim: Modern text editor with MSH configuration"
    echo
    
    # Demander confirmation
    if confirm_action "Would you like to install the missing tools automatically?"; then
        install_missing_core_tools "${missing_tools[@]}"
        return $?
    else
        echo
        log_info "Skipping core tools installation"
        echo "💡 You can install them manually later:"
        
        local os="$(detect_os)"
        for tool in "${missing_tools[@]}"; do
            local package_name="$(get_package_name "$tool" "$os")"
            case "$(detect_package_manager)" in
                "apt") echo "  sudo apt install $package_name" ;;
                "yay") echo "  yay -S $package_name" ;;
                "paru") echo "  paru -S $package_name" ;;
                "pacman") echo "  sudo pacman -S $package_name" ;;
                "dnf") echo "  sudo dnf install $package_name" ;;
                "brew") echo "  brew install $package_name" ;;
                *) echo "  # Install $tool using your package manager" ;;
            esac
        done
        
        return 1
    fi
}

# Installer tous les outils manquants
install_missing_core_tools() {
    local tools_to_install=("$@")
    local successful_installs=0
    local failed_installs=()
    
    echo
    log_section "📦 Installing missing core tools"
    
    for tool in "${tools_to_install[@]}"; do
        echo
        if install_core_tool "$tool"; then
            successful_installs=$((successful_installs + 1))
        else
            failed_installs+=("$tool")
        fi
    done
    
    echo
    echo "📊 Installation Results:"
    echo "  ✅ Successful: $successful_installs/${#tools_to_install[@]}"
    
    if [[ ${#failed_installs[@]} -gt 0 ]]; then
        echo "  ❌ Failed: ${failed_installs[*]}"
        log_warning "Some tools failed to install. You may need to install them manually."
        return 1
    else
        log_success "All core tools installed successfully!"
        return 0
    fi
}

# ===============================
# 🔧 FONCTION PRINCIPALE
# ===============================

# Vérification et installation interactive des outils de base
ensure_core_tools() {
    local force_check="${1:-false}"
    
    show_banner "Core Tools Verification"
    
    # Vérifier tous les outils
    if check_all_core_tools; then
        if [[ "$force_check" == "true" ]]; then
            echo
            log_success "✅ All core tools are properly installed!"
        fi
        return 0
    else
        # Proposer l'installation des outils manquants
        offer_core_tools_installation
        return $?
    fi
}

# ===============================
# 📊 FONCTIONS DE STATUT
# ===============================

# Afficher le statut détaillé des outils de base
show_core_tools_status() {
    echo "📊 MSH Core Tools Status:"
    echo
    
    local os="$(detect_os)"
    local package_manager="$(detect_package_manager)"
    
    echo "🖥️  System: $os ($package_manager)"
    echo
    
    for tool in "${!CORE_TOOLS[@]}"; do
        local description="${CORE_TOOLS[$tool]}"
        
        if check_core_tool "$tool"; then
            local version="$(get_tool_version "$tool")"
            echo "  ✅ $description: $version"
        else
            local package_name="$(get_package_name "$tool" "$os")"
            echo "  ❌ $description: Not installed (package: $package_name)"
        fi
    done
}

# Obtenir la version d'un outil
get_tool_version() {
    local tool="$1"
    
    case "$tool" in
        "zsh")
            zsh --version 2>/dev/null | head -1 | cut -d' ' -f2 || echo "unknown"
            ;;
        "tmux")
            tmux -V 2>/dev/null | cut -d' ' -f2 || echo "unknown"
            ;;
        "nvim")
            nvim --version 2>/dev/null | head -1 | cut -d' ' -f2 || echo "unknown"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}