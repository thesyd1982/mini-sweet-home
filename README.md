# 🏠 Mini Sweet Home v2.1 - Enhanced Edition

> **Configuration d'environnement modulaire avec installation automatique des plugins Neovim**

## 🚀 Installation Rapide (RECOMMANDÉE)

```bash
# Clone le repository
git clone https://github.com/user/mini-sweet-home.git
cd mini-sweet-home

# Installation enhanced avec auto-setup Neovim
make enhanced
```

## ✨ Nouveautés v2.1

- **🎯 Installation automatique des plugins Neovim** - Plugins prêts dès l'installation
- **🛠️ Commande `msh` améliorée** - Plus de fonctionnalités de maintenance
- **🔒 Support des lockfiles** - Versions cohérentes des plugins
- **⚡ Optimisations** - Installation plus rapide et stable

## 📦 Profils Disponibles

### 🏃‍♂️ Minimal (~3 min)
- Configuration ZSH, Tmux, Git de base
- **Neovim avec tous les plugins pré-installés**
- Parfait pour commencer rapidement

```bash
make minimal
```

### ⚡ Modern (~8 min)  
- Tout de Minimal +
- Outils modernes : `dust`, `ripgrep`, `fd`, `bat`, `eza`
- `starship` prompt + `zoxide` navigation
- Plugins Neovim installés automatiquement

```bash
make modern
```

### 👩‍💻 Developer (~15 min)
- Tout de Modern +
- Node.js + Language Servers (TypeScript, Bash)
- Configuration complète pour le développement
- Neovim prêt pour coder immédiatement

```bash
make developer  
```

### 🖥️ Server (~5 min)
- Configuration optimisée serveur
- Outils essentiels uniquement
- Neovim léger mais fonctionnel

```bash
make server
```

## 🛠️ Commandes Utiles

```bash
# Diagnostic complet
make doctor
msh doctor

# Mise à jour
make update
msh update

# Reconfigurer Neovim
make nvim
msh nvim

# Sauvegarder configs
msh backup

# Test de performance
msh benchmark

# Voir le statut
make status
```

## 🧪 Vérification

```bash
# Test complet de l'installation
make test

# Vérifier les plugins Neovim
nvim +checkhealth
```

## 🎯 Plugins Neovim Inclus

Tous ces plugins sont **automatiquement installés** et configurés :

### 🔧 Essentiels
- **Lazy.nvim** - Gestionnaire de plugins
- **Telescope** - Fuzzy finder
- **Treesitter** - Syntaxe avancée
- **LSP Config** - Language servers

### ⚡ Productivité  
- **Harpoon** - Navigation rapide
- **Oil.nvim** - Explorateur de fichiers
- **Which-key** - Aide raccourcis
- **Auto-pairs** - Parenthèses automatiques

### 🎨 Interface
- **Lualine** - Barre de statut
- **Rose Pine** - Thème élégant
- **Noice** - Interface moderne
- **Transparent** - Fond transparent

### 🚀 Développement
- **Codeium** - IA assistant
- **Conform** - Formatage automatique
- **Trouble** - Diagnostics
- **Git integration** - Fugitive

## 🔧 Configuration Personnalisée

### Modifier la config Neovim
```bash
# Éditer les configs
nvim ~/.config/nvim

# Ajouter des plugins dans
nvim ~/.config/nvim/lua/plugins/
```

### Personnaliser le shell
```bash
# Configs dans le repository
vzc  # Éditer ZSH config
valiases  # Éditer aliases
vfunctions  # Éditer functions
```

## 🆘 Dépannage

### Plugins Neovim non installés
```bash
# Réinstaller les plugins
msh nvim

# Ou manuellement dans Neovim
:Lazy install
:Lazy update
```

### Outils modernes manquants
```bash
# Réinstaller le profil
make modern

# Ou installer Rust d'abord
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Commande `msh` non trouvée
```bash
# Vérifier le PATH
echo $PATH | grep ~/.local/bin

# Recharger le shell
source ~/.zshrc

# Réinstaller
make enhanced
```

## 📁 Structure

```
mini-sweet-home/
├── setup-enhanced*     # Script d'installation amélioré
├── setup*             # Script classique
├── Makefile           # Commandes make
├── scripts/
│   ├── setup-neovim.sh*   # Installation Neovim spécialisée
│   └── msh*           # Utilitaire de maintenance
└── configs/
    ├── nvim/          # Configuration Neovim complète
    │   ├── lazy-lock.json  # Versions figées des plugins
    │   └── lua/
    ├── shell/zsh/     # Configuration ZSH
    ├── tmux/          # Configuration Tmux
    └── git/           # Configuration Git
```

## 🤝 Contributions

Les contributions sont bienvenues ! Zones d'amélioration :

- **Nouveaux plugins Neovim** dans `configs/nvim/lua/plugins/`
- **Outils CLI supplémentaires** dans `setup-enhanced`
- **Optimisations d'installation**
- **Support d'autres OS**

## 📄 Licence

MIT License - Utilisez librement pour vos projets !

---

**🎉 Profitez de votre nouvel environnement de développement !**

> Une fois installé, votre terminal aura tous les outils modernes et Neovim sera prêt avec tous les plugins configurés. Plus besoin d'attendre l'installation manuelle !
