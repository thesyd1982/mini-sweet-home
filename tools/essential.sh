#!/bin/bash

# ===============================
# 🛠️ OUTILS ESSENTIELS
# ===============================

# Colors and logging
log() { echo -e "\033[0;34m[INFO]\033[0m $1"; }
success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0m $1"; }

# Détection OS
detect_os() {
    if command -v apt >/dev/null 2>&1; then
        echo "ubuntu"
    elif command -v dnf >/dev/null 2>&1; then
        echo "fedora"
    elif command -v pacman >/dev/null 2>&1; then
        echo "arch"
    elif command -v brew >/dev/null 2>&1; then
        echo "macos"
    else
        echo "unknown"
    fi
}

log "Installation des outils essentiels..."

OS=$(detect_os)

# Installation des outils de base
case "$OS" in
    ubuntu)
        sudo apt update
        sudo apt install -y git curl wget zsh tmux neovim build-essential
        sudo apt install -y ripgrep fd-find exa btop bat
        ;;
    fedora)
        sudo dnf install -y git curl wget zsh tmux neovim gcc gcc-c++
        sudo dnf install -y ripgrep fd-find exa btop bat
        ;;
    arch)
        sudo pacman -Sy --noconfirm git curl wget zsh tmux neovim base-devel
        sudo pacman -S --noconfirm ripgrep fd exa btop dust bat
        ;;
    macos)
        brew install git curl wget zsh tmux neovim
        brew install ripgrep fd exa btop dust bat
        ;;
    *)
        warn "OS non supporté: $OS"
        return 1
        ;;
esac

# dust (modern du) pour Ubuntu/Fedora
if [[ "$OS" == "ubuntu" || "$OS" == "fedora" ]] && ! command -v dust >/dev/null 2>&1; then
    log "Installation de dust..."
    wget -qO- https://github.com/bootandy/dust/releases/latest/download/dust-v0.8.6-x86_64-unknown-linux-gnu.tar.gz | sudo tar xz -C /usr/local/bin --strip-components=1 dust-v0.8.6-x86_64-unknown-linux-gnu/dust 2>/dev/null || {
        # Fallback: installation via cargo si disponible
        if command -v cargo >/dev/null 2>&1; then
            cargo install du-dust
        fi
    }
fi

# fzf
if ! command -v fzf >/dev/null 2>&1; then
    log "Installation de fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

# zoxide
if ! command -v zoxide >/dev/null 2>&1; then
    log "Installation de zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# Plugins ZSH
if [[ ! -d "$HOME/.zsh-syntax-highlighting" ]]; then
    log "Installation de zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting"
fi

if [[ ! -d "$HOME/.zsh-autosuggestions" ]]; then
    log "Installation de zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh-autosuggestions"
fi

# TPM pour tmux
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    log "Installation de TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

success "Outils essentiels installés"
