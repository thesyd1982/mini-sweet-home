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
    ["nerd-fonts"]="Nerd Fonts (for icons)"
)

# Packages par OS pour chaque outil
declare -A UBUNTU_PACKAGES=(
    ["zsh"]="zsh"
    ["tmux"]="tmux"
    ["nvim"]="neovim"
    ["nerd-fonts"]="fonts-firacode"
)

declare -A ARCH_PACKAGES=(
    ["zsh"]="zsh"
    ["tmux"]="tmux"
    ["nvim"]="neovim"
    ["nerd-fonts"]="ttf-firacode-nerd"
)

declare -A FEDORA_PACKAGES=(
    ["zsh"]="zsh"
    ["tmux"]="tmux"
    ["nvim"]="neovim"
    ["nerd-fonts"]="fira-code-fonts"
)

declare -A MACOS_PACKAGES=(
    ["zsh"]="zsh"
    ["tmux"]="tmux"
    ["nvim"]="neovim"
    ["nerd-fonts"]="font-fira-code-nerd-font"
)

# ===============================
# 🔍 FONCTIONS DE VÉRIFICATION
# ===============================

# Vérifier si un outil de base est installé
check_core_tool() {
    local tool="$1"
    
    # Cas spécial pour les Nerd Fonts
    if [[ "$tool" == "nerd-fonts" ]]; then
        check_nerd_fonts
        return $?
    fi
    
    if command -v "$tool" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Vérifier si les Nerd Fonts sont installées
check_nerd_fonts() {
    # Vérification universelle via fc-list (plus fiable)
    if command -v fc-list >/dev/null 2>&1; then
        # Chercher toute Nerd Font populaire
        if fc-list | grep -i "nerd" >/dev/null 2>&1; then
            return 0
        fi
        
        # Chercher des fonts spécifiques avec support d'icônes
        if fc-list | grep -iE "(fira.*code|jetbrains.*mono|hack|source.*code)" >/dev/null 2>&1; then
            return 0
        fi
    fi
    
    # Méthodes de détection selon l'OS (packages)
    local os="$(detect_os)"
    
    case "$os" in
        "arch")
            # Vérifier via pacman
            if pacman -Qs ttf-firacode-nerd >/dev/null 2>&1 || pacman -Qs ttf-jetbrains-mono-nerd >/dev/null 2>&1; then
                return 0
            fi
            ;;
        "ubuntu"|"debian")
            # Vérifier via dpkg
            if dpkg -l | grep -iE "(fira.*code|jetbrains)" >/dev/null 2>&1; then
                return 0
            fi
            ;;
        "fedora"|"rhel"|"centos")
            # Vérifier via dnf
            if dnf list installed | grep -iE "(fira.*code|jetbrains)" >/dev/null 2>&1; then
                return 0
            fi
            ;;
    esac
    
    return 1
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
    
    # Cas spécial pour les Nerd Fonts
    if [[ "$tool" == "nerd-fonts" ]]; then
        install_nerd_fonts
        return $?
    fi
    
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

# Installer les Nerd Fonts selon l'OS
install_nerd_fonts() {
    local os="$(detect_os)"
    local package_manager="$(detect_package_manager)"
    
    echo "🔤 Installing Nerd Fonts on $os..."
    
    case "$package_manager" in
        "apt")
            # Ubuntu/Debian: installer via apt ou téléchargement direct
            if sudo apt update >/dev/null 2>&1 && sudo apt install -y fonts-firacode >/dev/null 2>&1; then
                log_success "FiraCode font installed via apt"
                # Installer aussi la version Nerd Font
                install_nerd_font_manual "FiraCode"
                return 0
            fi
            ;;
        "yay")
            if yay -S --noconfirm ttf-firacode-nerd >/dev/null 2>&1; then
                log_success "FiraCode Nerd Font installed via yay"
                return 0
            fi
            ;;
        "paru")
            if paru -S --noconfirm ttf-firacode-nerd >/dev/null 2>&1; then
                log_success "FiraCode Nerd Font installed via paru"
                return 0
            fi
            ;;
        "pacman")
            # Essayer d'abord les repos officiels, puis AUR
            if sudo pacman -S --noconfirm ttf-firacode >/dev/null 2>&1; then
                log_success "FiraCode font installed via pacman"
                log_info "Installing Nerd Font version manually..."
                install_nerd_font_manual "FiraCode"
                return 0
            fi
            ;;
        "dnf")
            if sudo dnf install -y fira-code-fonts >/dev/null 2>&1; then
                log_success "FiraCode font installed via dnf"
                install_nerd_font_manual "FiraCode"
                return 0
            fi
            ;;
        "brew")
            if brew install font-fira-code-nerd-font >/dev/null 2>&1; then
                log_success "FiraCode Nerd Font installed via brew"
                return 0
            fi
            ;;
    esac
    
    # Fallback: installation manuelle
    log_info "Package manager installation failed, trying manual installation..."
    install_nerd_font_manual "FiraCode"
    return $?
}

# Installation manuelle des Nerd Fonts
install_nerd_font_manual() {
    local font_name="${1:-FiraCode}"
    local font_dir
    
    # Déterminer le répertoire des fonts selon l'OS
    if [[ "$(uname)" == "Darwin" ]]; then
        font_dir="$HOME/Library/Fonts"
    else
        font_dir="$HOME/.local/share/fonts"
        mkdir -p "$font_dir"
    fi
    
    echo "📥 Downloading $font_name Nerd Font..."
    
    # URL de téléchargement (GitHub releases)
    local download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip"
    local temp_dir="/tmp/nerd-fonts-install"
    
    # Créer répertoire temporaire
    mkdir -p "$temp_dir"
    
    # Télécharger et installer
    if command -v curl >/dev/null 2>&1; then
        if curl -L "$download_url" -o "$temp_dir/${font_name}.zip" >/dev/null 2>&1; then
            if command -v unzip >/dev/null 2>&1; then
                cd "$temp_dir" && unzip -q "${font_name}.zip" && cp *.ttf "$font_dir/" 2>/dev/null
                
                # Rafraîchir le cache des fonts
                if command -v fc-cache >/dev/null 2>&1; then
                    fc-cache -f "$font_dir" >/dev/null 2>&1
                fi
                
                # Nettoyer
                rm -rf "$temp_dir"
                
                log_success "$font_name Nerd Font installed manually"
                log_info "You may need to restart your terminal to see the changes"
                return 0
            else
                log_error "unzip not found, cannot extract font"
            fi
        else
            log_error "Failed to download $font_name Nerd Font"
        fi
    else
        log_error "curl not found, cannot download font"
    fi
    
    # Nettoyer en cas d'échec
    rm -rf "$temp_dir"
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
    echo -n "Would you like to install the missing tools automatically? [y/N]: "
    read -r response
    
    if [[ "$response" =~ ^[Yy]([Ee][Ss])?$ ]]; then
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
        "nerd-fonts")
            get_nerd_fonts_info
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Obtenir des informations sur les Nerd Fonts installées
get_nerd_fonts_info() {
    if ! check_nerd_fonts; then
        echo "Not installed"
        return
    fi
    
    # Détecter quelle Nerd Font est installée
    if command -v fc-list >/dev/null 2>&1; then
        if fc-list | grep -i "jetbrains.*mono.*nerd" >/dev/null; then
            echo "JetBrains Mono Nerd Font"
        elif fc-list | grep -i "firacode.*nerd" >/dev/null; then
            echo "FiraCode Nerd Font"
        elif fc-list | grep -i "hack.*nerd" >/dev/null; then
            echo "Hack Nerd Font"
        elif fc-list | grep -i "source.*code.*nerd" >/dev/null; then
            echo "Source Code Pro Nerd Font"
        elif fc-list | grep -i "nerd" >/dev/null; then
            # Extraire le nom de la première Nerd Font trouvée
            local font_name="$(fc-list | grep -i "nerd" | head -1 | cut -d: -f2 | cut -d, -f1 | sed 's/^[[:space:]]*//')"
            echo "${font_name:-Nerd Font}"
        else
            echo "Available"
        fi
    else
        echo "Available"
    fi
}