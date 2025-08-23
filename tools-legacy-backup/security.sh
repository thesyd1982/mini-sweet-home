#!/bin/bash

# ===============================
# 🔒 OUTILS DE SÉCURITÉ
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

log "Installation des outils de sécurité..."

case "$(detect_os)" in
    ubuntu)
        sudo apt install -y nmap wireshark-common tcpdump netcat-openbsd
        sudo apt install -y sqlmap nikto dirb gobuster
        ;;
    fedora)
        sudo dnf install -y nmap wireshark tcpdump netcat
        sudo dnf install -y sqlmap nikto dirb
        ;;
    arch)
        sudo pacman -S --noconfirm nmap wireshark-cli tcpdump gnu-netcat
        sudo pacman -S --noconfirm sqlmap nikto dirb gobuster
        ;;
    macos)
        brew install nmap wireshark netcat
        brew install sqlmap nikto dirb gobuster
        ;;
esac

# Metasploit (optionnel)
if ! command -v msfconsole >/dev/null 2>&1; then
    log "Installation de Metasploit..."
    case "$(detect_os)" in
        ubuntu)
            curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
            chmod 755 msfinstall
            ./msfinstall
            rm msfinstall
            ;;
        macos)
            brew install metasploit
            ;;
    esac
fi

success "Outils de sécurité installés"
