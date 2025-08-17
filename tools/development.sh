#!/bin/bash

# ===============================
# 💻 OUTILS DE DÉVELOPPEMENT
# ===============================

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

log "Installation des outils de développement..."

# Node.js via NVM
if [[ ! -d "$HOME/.nvm" ]]; then
    log "Installation de NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
fi

# pnpm
if ! command -v pnpm >/dev/null 2>&1; then
    log "Installation de pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# Python tools
if command -v pip3 >/dev/null 2>&1; then
    log "Installation des outils Python..."
    pip3 install --user black flake8 mypy ruff
fi

# uv (gestionnaire Python ultra-rapide)
if ! command -v uv >/dev/null 2>&1; then
    log "Installation de uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Rust
if ! command -v rustc >/dev/null 2>&1; then
    log "Installation de Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    
    # Outils Rust utiles
    cargo install cargo-watch cargo-edit
fi

# Go
if ! command -v go >/dev/null 2>&1; then
    log "Installation de Go..."
    local go_version=$(curl -s https://go.dev/VERSION?m=text)
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew >/dev/null 2>&1; then
            brew install go
        fi
    else
        wget "https://go.dev/dl/${go_version}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf /tmp/go.tar.gz
        rm /tmp/go.tar.gz
        
        # Ajouter au PATH
        if ! grep -q "/usr/local/go/bin" ~/.bashrc; then
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        fi
    fi
fi

# Lua ecosystem
log "Installation de l'écosystème Lua..."
case "$(detect_os)" in
    ubuntu)
        sudo apt install -y lua5.4 lua5.4-dev luarocks
        ;;
    fedora)
        sudo dnf install -y lua lua-devel luarocks
        ;;
    arch)
        sudo pacman -S --noconfirm lua luarocks
        ;;
    macos)
        brew install lua luarocks
        ;;
esac

if command -v luarocks >/dev/null 2>&1; then
    luarocks install --local luacheck 2>/dev/null || true
    luarocks install --local busted 2>/dev/null || true
    luarocks install --local luacov 2>/dev/null || true
fi

success "Outils de développement installés"
