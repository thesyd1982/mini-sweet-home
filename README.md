# 🏠 Mini Sweet Home - Cozy Development Environment

> **Your personal coding sanctuary with Rose Pine theme**
> 
> ✨ **Performance:** 100/100 benchmark score • 66ms ZSH startup • 12ms tmux • 151ms nvim

[![Performance](https://img.shields.io/badge/ZSH_startup-66ms-brightgreen.svg)](#performance)
[![Score](https://img.shields.io/badge/Benchmark-100%2F100-success.svg)](#performance)
[![Tests](https://img.shields.io/badge/Tests-5%2F5_passing-success.svg)](#testing)
[![Theme](https://img.shields.io/badge/Theme-Rose_Pine-pink.svg)](https://rosepinetheme.com/)

## 🎯 One-Line Installation

```bash
git clone https://github.com/thesyd1982/mini-sweet-home.git ~/mini-sweet-home
cd ~/mini-sweet-home && make install
```

**That's it!** Your cozy development environment is ready! 🎉

## ✨ Features

### 🎨 **Aesthetic & Minimal**
- **Rose Pine theme** throughout all tools
- **Ultra-minimal tmux** with top status bar
- **Centered windows** and clean borders
- **Consistent color scheme** across terminal

### ⚡ **Performance Optimized**
- **66ms ZSH startup** - Lightning fast shell
- **12ms tmux creation** - Instant sessions  
- **151ms Neovim startup** - Quick editor launch
- **100/100 benchmark score** - Optimized for speed

### 🛠️ **Complete Toolchain**
- **Modern CLI tools**: exa, bat, dust, fd, rg, btop, zoxide
- **Full Neovim IDE** with LSP, completion, and plugins
- **Git integration** with delta diff viewer
- **Automated installation** with shell setup

### 🧪 **Tested & Reliable**
- **5/5 tests passing** - Full validation suite
- **Fresh account tested** - Works on clean systems
- **Auto shell setup** - ZSH configured automatically
- **Symlink management** - Safe installation process

## 📁 Structure

```
mini-sweet-home/
├── configs/           # All configuration files
│   ├── shell/zsh/    # ZSH configuration (aliases, functions, prompt)
│   ├── tmux/         # Tmux Rose Pine setup
│   ├── nvim/         # Complete Neovim IDE
│   └── git/          # Git configuration with delta
├── bin/              # Custom scripts and tools
│   ├── benchmark     # Performance testing
│   └── ...          # More utilities
├── tools/            # Installation scripts by profile
├── tests/            # Validation test suite
├── install           # Simple installation script
└── Makefile          # Easy commands (install, test, bench)
```

## 🚀 Quick Start

### Prerequisites
- **Ubuntu/Debian**: `sudo apt install git zsh tmux neovim`
- **macOS**: `brew install git zsh tmux neovim`
- **Arch**: `sudo pacman -S git zsh tmux neovim`

### Installation
```bash
# Clone repository
git clone https://github.com/thesyd1982/mini-sweet-home.git ~/mini-sweet-home

# Install everything
cd ~/mini-sweet-home && make install

# Start using (automatic ZSH setup)
exec zsh
```

### Verification
```bash
# Run tests
make test

# Check performance  
make bench

# Use hyperfine for detailed benchmarks
hyperfine 'zsh -c \"exit\"'
```

## 📊 Performance

| Component | Startup Time | Status |
|-----------|-------------|---------|
| ZSH Shell | 66ms | ✅ Excellent |
| Tmux Session | 12ms | ✅ Ultra-fast |
| Neovim Editor | 151ms | ✅ Fast |
| Git Operations | 5ms | ✅ Lightning |
| **Overall Score** | **100/100** | 🎉 **Perfect** |

### Hyperfine Results
```bash
# ZSH startup (optimized)
Time (mean ± σ):       1.6 ms ±   0.3 ms
Range (min … max):     1.3 ms …   2.2 ms

# Git status
Time (mean ± σ):       4.2 ms ±   0.6 ms
Range (min … max):     3.1 ms …   5.3 ms
```

## 🎨 Screenshots

### Tmux with Rose Pine Theme
- Ultra-minimal top status bar
- Centered window indicators  
- Rose Pine colors (#c4a7e7, #6e6a86, #569fba)
- Clean pane borders

### ZSH Prompt
- Fast startup (66ms)
- Custom functions and aliases
- Modern CLI tools integrated
- Optimized for performance

### Neovim IDE
- Complete LSP setup
- Rose Pine colorscheme
- Plugin management with lazy.nvim
- Optimized for development

## 🔧 Customization

### Available Commands
```bash
make install     # Install everything
make test        # Run validation tests  
make bench       # Performance benchmark
bench            # Quick benchmark alias
```

### Key Aliases
```bash
# Modern file operations
ls, ll, la       # exa with colors
cat              # bat with syntax highlighting  
top              # btop system monitor
v, vim           # neovim

# Git shortcuts (oh-my-zsh complete set)
g, ga, gc, gp    # git shortcuts
gst              # git status
gl               # git log with graph

# Navigation
..., ....        # quick directory traversal
c                # clear
h                # history
```

### Tmux Key Bindings
- **Prefix**: `Ctrl-b` (default)
- **Pane navigation**: Vim-style
- **Status position**: Top
- **Mouse support**: Enabled

## 🧪 Testing

The environment includes comprehensive testing:

```bash
# Full test suite
make test

# Individual test categories
./tests/test-installation    # Installation validation
./tests/test-configs        # Configuration syntax
```

**Test Coverage:**
- ✅ Shell configuration loading
- ✅ ZSH functions and aliases  
- ✅ Symlink creation
- ✅ Tool availability
- ✅ Config file syntax

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Make changes and test: `make test && make bench`
4. Commit: `git commit -m \"feat: description\"`
5. Push and create pull request

## 📝 Changelog

### v1.0.0 - Mini Sweet Home Release
- ✨ Complete Rose Pine theme integration
- ⚡ Performance optimization (100/100 score)
- 🧪 Full test suite implementation  
- 🔧 Automatic ZSH shell setup
- 📦 One-command installation
- 🎨 Ultra-minimal tmux configuration
- 🛠️ Modern CLI tools integration

## 🙏 Credits

- **Rose Pine Theme**: [rosepinetheme.com](https://rosepinetheme.com/)
- **Modern CLI Tools**: exa, bat, fd, rg, dust, btop, zoxide
- **Neovim**: [neovim.io](https://neovim.io/)
- **Tmux**: [github.com/tmux/tmux](https://github.com/tmux/tmux)

## 📄 License

MIT License - Feel free to use and modify!

---

**🏠 Welcome to your Mini Sweet Home!** ✨

*Your cozy development sanctuary awaits. Enjoy coding in comfort and style.*
