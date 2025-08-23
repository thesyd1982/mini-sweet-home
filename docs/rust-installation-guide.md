# 🦀 Installation Rust, Cargo et dust

Ce guide couvre l'installation complète de Rust, Cargo et dust avec toutes les optimisations pour votre environnement de développement.

## 🚀 Installation rapide

### Option 1 : Installation complète (recommandée)
```bash
# Installation complète avec optimisations
make rust-full
```

### Option 2 : Installation par étapes
```bash
# 1. Installer Rust/Cargo seulement
make rust

# 2. Installer dust uniquement (après avoir Rust)
make dust
```

### Option 3 : Script manuel
```bash
# Installation complète avec script dédié
chmod +x bin/install-rust-dust
./bin/install-rust-dust
```

## 🛠️ Outils installés

### Rust Toolchain
- **rustc** : Compilateur Rust
- **cargo** : Gestionnaire de paquets et build tool
- **rustup** : Gestionnaire de versions Rust

### Outils CLI modernes
- **dust** (`du-dust`) : Analyseur d'espace disque moderne
- **ripgrep** (`rg`) : Recherche ultra-rapide
- **fd** (`fd-find`) : Alternative moderne à `find`
- **bat** : `cat` avec coloration syntaxique
- **exa** : `ls` moderne avec icônes
- **zoxide** : `cd` intelligent avec historique
- **starship** : Prompt shell moderne et rapide

### Outils de développement Cargo
- **cargo-watch** : Surveillance automatique des fichiers
- **cargo-edit** : Édition simplifiée de Cargo.toml
- **cargo-update** : Mise à jour des outils installés

## 🎯 Utilisation de dust

### Commandes de base
```bash
# Analyser le répertoire actuel
dust

# Analyser un répertoire spécifique
dust /home/user/documents

# Limiter la profondeur d'analyse
dust -d 2

# Afficher seulement les 10 plus gros éléments
dust -n 10

# Inverser l'ordre (plus gros en premier)
dust -r

# Rester sur le même système de fichiers
dust -x

# Format de sortie en arbre
dust -t
```

### Exemples pratiques
```bash
# Analyser votre home avec profondeur limitée
dust -d 3 ~

# Trouver les gros dossiers dans /var
sudo dust -n 5 /var

# Analyser un projet avec exclusions
dust --ignore-dir node_modules --ignore-dir target .

# Sortie en JSON pour traitement
dust --output json /path/to/analyze
```

## ⚙️ Configuration avancée

### Variables d'environnement
```bash
# Ajouter à ~/.zshrc ou ~/.bashrc
export DUST_COLORS="true"
export DUST_IGNORE_DIRS="node_modules,target,.git"
```

### Aliases recommandés
```bash
# Déjà configurés automatiquement
alias du='dust'
alias ls='exa --icons --group-directories-first'
alias ll='exa -la --icons --group-directories-first'
alias tree='exa --tree --icons'
alias cat='bat --paging=never'
alias find='fd'
alias grep='rg'
```

## 🔄 Mise à jour

### Mettre à jour tous les outils Rust
```bash
make rust-update
```

### Mettre à jour manuellement
```bash
# Mettre à jour Rust
rustup update

# Mettre à jour les outils cargo
cargo install-update -a
```

## 🐛 Dépannage

### Problèmes courants

#### 1. `cargo: command not found`
```bash
# Sourcer l'environnement Rust
source ~/.cargo/env

# Ou redémarrer le terminal
exec $SHELL
```

#### 2. Erreurs de compilation
```bash
# Vérifier les dépendances système
sudo apt update
sudo apt install build-essential pkg-config libssl-dev

# Sur Fedora
sudo dnf groupinstall "Development Tools"
sudo dnf install openssl-devel pkg-config
```

#### 3. Problèmes de permissions
```bash
# Corriger les permissions Cargo
chmod -R 755 ~/.cargo
```

#### 4. Cache corrompu
```bash
# Nettoyer le cache Cargo
cargo clean
rm -rf ~/.cargo/registry/cache
```

### WSL spécifique

#### Optimisations pour WSL
```bash
# Utiliser un répertoire temporaire sur /tmp pour les builds
export CARGO_TARGET_DIR="/tmp/cargo-target"

# Ou dans ~/.cargo/config.toml
[build]
target-dir = "/tmp/cargo-target"
```

#### Performance WSL
```bash
# Exclure le répertoire cargo de Windows Defender
# Dans PowerShell en tant qu'administrateur :
Add-MpPreference -ExclusionPath "\\wsl$\Ubuntu\home\username\.cargo"
```

## 📊 Benchmarks

### Comparaison avec les outils traditionnels

| Outil | Traditionnel | Rust moderne | Amélioration |
|-------|-------------|--------------|-------------|
| `du` | `du -sh` | `dust` | ~3x plus rapide |
| `find` | `find` | `fd` | ~5-10x plus rapide |
| `grep` | `grep -r` | `ripgrep` | ~5-15x plus rapide |
| `cat` | `cat` | `bat` | Même vitesse + coloration |
| `ls` | `ls -la` | `exa -la` | Même vitesse + icônes |

### Test de performance dust
```bash
# Benchmark automatique
time dust /usr
time du -sh /usr/*

# Généralement dust est 2-3x plus rapide que du
```

## 🔧 Configuration personnalisée

### Configuration dust avancée
```bash
# Créer un fichier de config dust
mkdir -p ~/.config/dust
cat > ~/.config/dust/config.toml << 'EOF'
# Configuration par défaut
depth = 3
number_of_lines = 20
reverse = false
bars_on_right = false
screen_reader = false

# Ignorer certains patterns
ignore_patterns = [
    "node_modules",
    "target",
    ".git",
    "*.tmp",
    "*.log"
]
EOF
```

### Intégration avec d'autres outils
```bash
# Utiliser dust avec fzf pour navigation interactive
dust | fzf

# Utiliser avec watch pour monitoring en temps réel
watch -n 5 'dust -n 10 /var/log'

# Combiner avec ripgrep pour analyser le contenu
dust | rg "large-file-pattern"
```

## 🎨 Customisation visuelle

### Thèmes pour bat
```bash
# Lister les thèmes disponibles
bat --list-themes

# Utiliser un thème spécifique
export BAT_THEME="Dracula"
```

### Configuration exa
```bash
# Variables d'environnement pour exa
export EXA_COLORS="da=1;34:gm=1;34"
export EXA_ICON_SPACING=2
```

### Configuration starship (prompt)
```bash
# Générer la configuration par défaut
starship config > ~/.config/starship.toml

# Configuration minimale pour la rapidité
cat > ~/.config/starship.toml << 'EOF'
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = "🌱 "

[rust]
symbol = "🦀 "
EOF
```

## 📚 Ressources

### Documentation officielle
- [Rust Book](https://doc.rust-lang.org/book/)
- [Cargo Book](https://doc.rust-lang.org/cargo/)
- [dust GitHub](https://github.com/bootandy/dust)

### Communauté
- [r/rust](https://reddit.com/r/rust)
- [Rust Users Forum](https://users.rust-lang.org/)
- [Discord Rust](https://discord.gg/rust-lang)

### Autres outils Rust utiles
- [tokei](https://github.com/XAMPPRocky/tokei) - Compteur de lignes de code
- [hyperfine](https://github.com/sharkdp/hyperfine) - Benchmarking
- [delta](https://github.com/dandavison/delta) - Diff viewer
- [procs](https://github.com/dalance/procs) - ps moderne
- [bottom](https://github.com/ClementTsang/bottom) - htop/top moderne

## 🏁 Scripts disponibles

| Script | Description | Usage |
|--------|-------------|-------|
| `install-rust-dust` | Installation complète | `./bin/install-rust-dust` |
| `install-dust-only` | Dust uniquement | `./bin/install-dust-only` |
| `update-rust-tools` | Mise à jour | `./bin/update-rust-tools` |
| `fix-markdown-preview` | Fix WSL Markdown | `./bin/fix-markdown-preview` |

Tous ces scripts sont optimisés pour votre environnement et incluent une détection automatique de l'OS et des optimisations spécifiques à WSL si applicable.
