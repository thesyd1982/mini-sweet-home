# 🏗️ MSH v3.0 - Arch Linux Installation Guide

## 🎯 Overview

MSH v3.0 now supports Arch Linux with native package management integration, including AUR support via `yay` or `paru`.

## 📋 Prerequisites

### Required
- Arch Linux system
- `sudo` access
- Internet connection

### Recommended
- `base-devel` package group
- `git` package
- AUR helper (`yay` or `paru`)

## 🚀 Quick Installation

```bash
# Clone MSH
git clone https://github.com/yourusername/mini-sweet-home.git
cd mini-sweet-home

# Install everything
./msh install
```

## 🔧 Installation Methods

MSH uses multiple installation methods in this priority order:

### 1. **AUR Helper** (Preferred)
- `yay -S package`
- `paru -S package`

### 2. **Official Repositories**
- `sudo pacman -S package`

### 3. **Cargo** (Rust packages)
- `cargo install package`

### 4. **GitHub Binaries**
- Direct binary downloads

### 5. **Intelligent Fallbacks**
- Native alternatives

## 📦 Package Mapping

| Tool | Arch Package | AUR | Official |
|------|-------------|-----|----------|
| `rg` | `ripgrep` | ✅ | ✅ |
| `fd` | `fd` | ✅ | ✅ |
| `bat` | `bat` | ✅ | ✅ |
| `eza` | `eza` | ✅ | ✅ |
| `dust` | `dust` | ✅ | ✅ |
| `fzy` | `fzy` | ✅ | ❌ |
| `zoxide` | `zoxide` | ✅ | ✅ |
| `cmake` | `cmake` | ✅ | ✅ |

## 🛠️ AUR Helper Setup

If you don't have an AUR helper, MSH will automatically install `yay`:

```bash
# This happens automatically during MSH installation
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

## 🧪 Testing Installation

```bash
# Test Arch support (simulation)
./test-arch-support.sh

# Check system status
./msh status

# Verify tools
./msh test
```

## 🔍 Troubleshooting

### AUR Helper Issues
```bash
# Manual yay installation
sudo pacman -S base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si --noconfirm
```

### Package Conflicts
```bash
# Remove conflicting packages
sudo pacman -R conflicting-package

# Reinstall MSH tools
./msh install
```

### Permission Issues
```bash
# Fix permissions
sudo chown -R $USER:$USER ~/.cache/yay
sudo chown -R $USER:$USER ~/.config/yay
```

## 📊 Verification

After installation, verify everything works:

```bash
# Check all tools
rg --version
fd --version
bat --version
eza --version
dust --version
fzy --version || echo "fzy fallback active"
zoxide --version
cmake --version

# Check MSH status
./msh status
```

## 🎯 Arch-Specific Features

### Optimized Package Selection
- Prefers AUR packages for latest versions
- Falls back to official repos for stability
- Uses `yay` over `paru` when both available

### Smart Dependency Handling
- Automatically installs `base-devel` if needed
- Handles package conflicts gracefully
- Provides detailed installation feedback

### Performance Optimizations
- Parallel installations where possible
- Minimal package downloads
- Efficient fallback chains

## 🔄 Updates

```bash
# Update MSH
git pull origin main

# Update all tools
yay -Syu

# Reinstall if needed
./msh reinstall
```

## 💡 Tips

1. **Use AUR helper**: Install `yay` or `paru` for best experience
2. **Keep system updated**: `sudo pacman -Syu` regularly
3. **Check logs**: MSH logs to `~/.msh-install.log`
4. **Test changes**: Use `./test-arch-support.sh` before major updates

## 🆘 Support

If you encounter issues:

1. Check `~/.msh-install.log`
2. Run `./msh debug-path`
3. Test with `./test-arch-support.sh`
4. Open an issue with system info

---

**MSH v3.0 - Professional Development Environment for Arch Linux** 🏗️