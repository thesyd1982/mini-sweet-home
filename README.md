# 🚀 Dotfiles V4 - Configuration Portable Intelligente

> **Setup hyperminimaliste et portable pour développeur avec workflow optimisé**
> 
> ✨ **Structure V4:** Organisation parfaite • Installation simplifiée • Scripts réutilisables

[![Version](https://img.shields.io/badge/version-4.0.0-blue.svg)](https://github.com/votre-username/dotfiles)
[![OS Support](https://img.shields.io/badge/OS-Ubuntu%20%7C%20Debian%20%7C%20Fedora%20%7C%20Arch%20%7C%20macOS-green.svg)](#)

## 🎯 Installation Une Ligne

```bash
# Installation interactive (recommandé)
./install

# Installation par profil
./install minimal        # Configuration de base
./install developer      # Profil développeur complet
./install devops         # Outils DevOps + containers
./install complete       # Installation complète

# Ou avec Make
make install            # Installation minimale
make developer          # Profil développeur
```

## 📁 Structure V4 Parfaite

```
dotfiles/
├── install                    # 🚀 Script d'installation unique
├── Makefile                  # 🛠️ Commandes make simples
│
├── configs/                  # 📄 Configurations pures
│   ├── shell/zsh/           # ZSH modulaire
│   ├── tmux/                # Tmux + layouts
│   ├── git/                 # Git config
│   └── nvim/                # Neovim complet
│
├── bin/                     # 🔧 Scripts exécutables
│   ├── project-switch       # Sélecteur projets + tmux auto
│   ├── session-manager      # Gestionnaire sessions tmux
│   └── dev-setup           # Setup environnement dev
│
├── tools/                   # 📦 Installation outils
│   ├── essential.sh         # fzf, zoxide, exa, etc.
│   ├── development.sh       # node, python, rust, go
│   └── devops.sh           # docker, kubectl, terraform
│
└── tests/                   # 🧪 Tests de validation
    ├── test-installation
    └── test-configs
```

## 🌟 Fonctionnalités V4

### ⚡ **Performance Optimisée**
- **Démarrage ultra-rapide** (~30ms vs 3000ms+)
- **NVM lazy loading** intelligent
- **Configuration modulaire** et optimisée
- **Pas de frameworks lourds** (Oh-My-Zsh optionnel)

### 🔧 **Outils Modernes Intégrés**
```bash
# Navigation intelligente
j <query>                 # zoxide navigation
sp                       # project switcher + tmux auto
kcef                     # accès rapide projet KCE

# Git workflow optimisé
gq s/a/c/p/pl           # commandes git rapides
gst, gaa, gcm           # tous les alias Git OMZ

# Session management
tm new [name]           # créer/rejoindre session tmux
session-manager dev     # layout développement auto
```

### 🎯 **Profils Intelligents**
- **minimal** - Configuration de base + outils essentiels
- **developer** - Node, Python, Rust, Go + outils dev
- **devops** - Docker, Kubernetes, Terraform, Ansible
- **data-science** - Python + Jupyter + bibliothèques data
- **security** - Outils de pentesting et sécurité
- **complete** - Installation complète

## 🚀 Guide de Démarrage Rapide

### 1. Installation Express
```bash
git clone <your-repo> ~/mini-sweet-home
cd ~/mini-sweet-home
./install developer      # ou votre profil préféré
```

### 2. Activation
```bash
source ~/.zshrc         # Activer la nouvelle config
commands               # Voir toutes les commandes
sp                     # Tester le project switcher
```

### 3. Commandes Essentielles
```bash
# Navigation
j ~/projects           # Navigation zoxide
sp                     # Project switcher avec tmux auto
kcef                   # Aller au projet KCE

# Development
tm new myproject       # Session tmux pour projet
dev-setup --tmux       # Setup environnement + tmux
session-manager dev    # Layout développement

# Git workflow
gq s                   # git status
gq a                   # git add .
gq c "message"         # git commit -m
gq p                   # git push
```

## 🛠️ Gestion et Maintenance

### Tests et Validation
```bash
make test              # Tester l'installation
./tests/test-configs   # Valider les configurations
./install --analyze    # Analyser config actuelle
```

### Sauvegarde et Restauration
```bash
make backup            # Sauvegarder configs actuelles
./install --uninstall  # Désinstaller et restaurer
```

### Mise à Jour
```bash
git pull              # Mettre à jour les dotfiles
./install             # Réinstaller avec nouveau code
```

## 📦 Outils Installés par Profil

### Minimal
- **Core:** git, zsh, tmux, neovim
- **Modern CLI:** fzf, zoxide, exa, ripgrep, btop
- **ZSH:** syntax-highlighting, autosuggestions

### Developer (+ Minimal)
- **Node.js:** nvm, pnpm
- **Python:** uv, black, flake8, mypy
- **Rust:** rustup, cargo-watch, cargo-edit
- **Go:** latest version
- **Lua:** lua, luarocks, luacheck

### DevOps (+ Developer)
- **Containers:** docker, docker-compose
- **Orchestration:** kubectl, helm
- **Infrastructure:** terraform, ansible

## 🎨 Personnalisation

### Structure Modulaire
Chaque configuration est dans son propre fichier :
```bash
configs/shell/zsh/
├── zshrc              # Configuration principale
├── aliases.zsh        # Tous les alias
├── functions.zsh      # Fonctions personnalisées
├── exports.zsh        # Variables d'environnement
└── prompt.zsh         # Prompt avec git status
```

### Ajout de Fonctionnalités
```bash
# Ajouter un script personnel
echo '#!/bin/bash\necho "Mon script"' > bin/mon-script
chmod +x bin/mon-script

# Ajouter des alias personnalisés
echo "alias ms='mon-script'" >> configs/shell/zsh/aliases.zsh
```

## 🐛 Dépannage

### Problèmes Courants
```bash
# Conflit avec zoxide
source ~/.zshrc        # Recharger config

# Erreur de chargement NVM
unset NVM_DIR          # Reset NVM
source ~/.zshrc        # Recharger

# Performance lente
./tests/benchmark      # Tester performance startup
```

### Support
- 📖 **Documentation:** `/docs`
- 🧪 **Tests:** `make test`
- 🔍 **Analyse:** `./install --analyze`

## 🎯 Avantages de cette Structure

1. **📁 Séparation claire** : configs / outils / scripts / tests
2. **🎯 Un seul point d'entrée** : `./install` 
3. **📦 Profils modulaires** : choix selon besoin
4. **🔧 Scripts réutilisables** : dans `bin/` et dans le PATH
5. **🧪 Tests intégrés** : validation automatique
6. **📚 Documentation claire** : README + docs/
7. **🛠️ Maintenance facile** : Makefile + scripts

---

**🚀 Profitez de vos nouveaux dotfiles V4 parfaitement organisés !**
