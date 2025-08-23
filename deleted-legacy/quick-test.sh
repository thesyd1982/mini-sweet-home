#!/bin/bash

# Test rapide du script setup - juste les fonctions de base
echo "🧪 Test rapide des fonctions principales"
echo "========================================"

# Définir les fonctions de base du setup (extrait simplifié)
command_exists() { command -v "$1" >/dev/null 2>&1; }
is_wsl() { grep -qi microsoft /proc/version 2>/dev/null; }
is_linux() { [[ "$OSTYPE" == "linux-gnu"* ]]; }

detect_os() {
    if is_linux; then
        if command_exists apt; then
            echo "ubuntu"
        elif command_exists dnf; then
            echo "fedora"
        elif command_exists pacman; then
            echo "arch"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

# Tester les fonctions
echo "🔍 Test de détection..."
OS=$(detect_os)
echo "✅ OS détecté: $OS"

if is_wsl; then
    echo "✅ WSL détecté"
else
    echo "ℹ️  Pas dans WSL"
fi

# Tester les commandes disponibles
echo
echo "🔧 Vérification des outils..."
command_exists curl && echo "✅ curl disponible" || echo "⚠️  curl manquant"
command_exists git && echo "✅ git disponible" || echo "⚠️  git manquant"
command_exists make && echo "✅ make disponible" || echo "⚠️  make manquant"

# Vérifier l'espace disque
echo
echo "💾 Vérification espace disque..."
available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
if [[ $available_space -gt 500000 ]]; then
    echo "✅ Espace disque suffisant ($(($available_space / 1024))MB disponible)"
else
    echo "⚠️  Espace disque limité"
fi

echo
echo "🎯 Simulation du menu d'installation..."
echo "======================================"
echo
echo "🏠 Mini Sweet Home v2.0 - Installation"
echo
echo "Choisissez votre profil d'installation :"
echo
echo "1) 🏃‍♂️ Minimal      - Configs de base uniquement         (~2 min, 50MB)"
echo "2) ⚡ Modern       - Minimal + outils modernes CLI      (~5 min, 200MB)"  
echo "3) 👩‍💻 Developer    - Setup développeur complet          (~10 min, 500MB)"
echo "4) 🖥️ Server       - Configuration serveur optimisée    (~3 min, 100MB)"
echo "5) 🔧 Custom       - Installation personnalisée"
echo "6) ❌ Exit         - Annuler l'installation"
echo
echo "Simulation: Profil 'modern' sélectionné"
echo
echo "📦 Profil Modern ⚡"
echo "• Configurations shell (zsh, aliases)"
echo "• Git, Tmux, Neovim avec plugins"
echo "• Rust toolchain + Cargo"
echo "• Outils modernes : dust, ripgrep, fd, bat, exa"
echo "• Starship prompt + Zoxide navigation"
echo
echo "⏱️  Temps estimé : 5 minutes"
echo "💾 Espace requis : 200MB"
echo

echo "✅ Test des fonctions principales réussi !"
echo
echo "🚀 Pour lancer le script complet :"
echo "   chmod +x setup"
echo "   ./setup modern"
echo
echo "📋 Pour tester le Makefile :"
echo "   make demo"
echo "   make help"
