# 🔧 Prérequis - Mini Sweet Home

## Prérequis Obligatoires

### Installation Minimale

Les outils suivants sont **OBLIGATOIRES** pour tous les profils d'installation :

#### 1. curl
- **Utilisation** : Téléchargement de fichiers, API calls, installation d'outils
- **Installation** :
  ```bash
  # Ubuntu/Debian
  sudo apt install curl
  
  # macOS
  brew install curl
  
  # Fedora
  sudo dnf install curl
  
  # Arch Linux
  sudo pacman -S curl
  ```

#### 2. git
- **Utilisation** : Gestion de versions, téléchargement de repositories
- **Installation** :
  ```bash
  # Ubuntu/Debian
  sudo apt install git
  
  # macOS
  brew install git
  
  # Fedora  
  sudo dnf install git
  
  # Arch Linux
  sudo pacman -S git
  ```

## Installation Automatique

Un script d'installation automatique est disponible :

```bash
# Installation automatique des prérequis
./scripts/install-prerequisites
```

Ce script :
- ✅ Détecte automatiquement votre OS
- ✅ Installe curl et git si manquants
- ✅ Vérifie que l'installation a réussi
- ✅ Supporte Ubuntu, macOS, Fedora, Arch Linux

## Vérification Manuelle

Pour vérifier si les prérequis sont installés :

```bash
# Vérifier curl
curl --version

# Vérifier git
git --version
```

## OS Supportés

### ✅ Supportés
- **Ubuntu/Debian** - Installation via apt
- **macOS** - Installation via Homebrew
- **Fedora** - Installation via dnf
- **Arch Linux** - Installation via pacman
- **CentOS/RHEL** - Installation via yum

### ⚠️ Partiellement supportés
- **WSL** - Utilise les commandes Linux correspondantes
- **Git Bash/MSYS2** - Installation manuelle requise

### ❌ Non supportés
- **Windows PowerShell natif** - Utilisez WSL ou Git Bash

## Dépannage

### curl manquant
```bash
curl: command not found
```
**Solution** : Installez curl avec votre gestionnaire de paquets

### git manquant  
```bash
git: command not found
```
**Solution** : Installez git avec votre gestionnaire de paquets

### Permissions insuffisantes
```bash
Permission denied
```
**Solution** : Utilisez `sudo` pour les commandes d'installation

## Après Installation

Une fois curl et git installés, vous pouvez procéder à l'installation de Mini Sweet Home :

```bash
# Installation rapide
curl -sSL <url>/setup | bash

# Ou installation locale
./setup minimal
```

## Questions Fréquentes

**Q: Pourquoi curl et git sont-ils obligatoires ?**
R: curl est nécessaire pour télécharger des outils et configurations, git pour gérer les versions et télécharger des repositories.

**Q: Puis-je utiliser wget au lieu de curl ?**
R: Non, le script utilise spécifiquement curl pour ses fonctionnalités avancées.

**Q: L'installation fonctionne-t-elle sans sudo ?**
R: L'installation des prérequis système nécessite sudo, mais l'installation de Mini Sweet Home se fait dans votre $HOME.