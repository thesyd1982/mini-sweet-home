#!/bin/bash

# ===============================
# 🐳 OUTILS DEVOPS
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

log "Installation des outils DevOps..."

# Docker
if ! command -v docker >/dev/null 2>&1; then
    log "Installation de Docker..."
    case "$(detect_os)" in
        ubuntu|fedora)
            curl -fsSL https://get.docker.com | sh
            sudo usermod -aG docker "$USER"
            ;;
        arch)
            sudo pacman -S --noconfirm docker
            sudo systemctl enable docker
            sudo usermod -aG docker "$USER"
            ;;
        macos)
            warn "Installez Docker Desktop manuellement sur macOS"
            ;;
    esac
fi

# kubectl
if ! command -v kubectl >/dev/null 2>&1; then
    log "Installation de kubectl..."
    case "$(detect_os)" in
        ubuntu|fedora|arch)
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            rm kubectl
            ;;
        macos)
            brew install kubectl
            ;;
    esac
fi

# Terraform
if ! command -v terraform >/dev/null 2>&1; then
    log "Installation de Terraform..."
    case "$(detect_os)" in
        ubuntu)
            wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            sudo apt update && sudo apt install terraform
            ;;
        macos)
            brew install terraform
            ;;
    esac
fi

# Ansible
if ! command -v ansible >/dev/null 2>&1; then
    log "Installation d'Ansible..."
    case "$(detect_os)" in
        ubuntu)
            sudo apt install -y ansible
            ;;
        fedora)
            sudo dnf install -y ansible
            ;;
        arch)
            sudo pacman -S --noconfirm ansible
            ;;
        macos)
            brew install ansible
            ;;
    esac
fi

success "Outils DevOps installés"
