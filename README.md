# 🏠 Mini Sweet Home (MSH) v3.0

**Professional Development Environment Management System for Linux**

MSH v3.0 is a comprehensive, modular development environment manager that provides intelligent tool installation, configuration management, and multi-shell support (zsh, bash, powershell) with a focus on performance and reliability.

## ✨ Features

### 🔧 **Core Functionality**
- **Intelligent Tool Installation**: Bulletproof installer with multi-OS support (Ubuntu, Arch Linux, etc.)
- **Modern Development Tools**: 8 essential tools (fzy, rg, fd, bat, eza, dust, zoxide, cmake)
- **Multi-Shell Support**: Native support for zsh, bash, and powershell
- **Modular Architecture**: Clean separation with `bin/`, `lib/`, `config/` structure
- **Smart Path Detection**: Multiple strategies for flexible installation locations

### 🛡️ **Advanced Path Detection**
MSH v3.0 features a robust path detection system that works in any environment:

1. **Environment Variable**: `MSH_PROJECT_DIR=/custom/path`
2. **System Installation**: Automatic detection when installed via symlink
3. **Direct Execution**: Works when running `./msh` from project directory
4. **Multiple Locations**: Searches `~/mini-sweet-home`, `~/.config/msh`, `~/Development/mini-sweet-home`
5. **Validation**: Strict directory structure validation with helpful error messages

### 🔐 **Secrets Management**
- Secure `.env` system for API keys and secrets
- Built-in secrets management tool (`msh secrets`)
- Template-based configuration with `.env.template`
- Automatic loading in shell environments

### 🎨 **Shell Enhancements**
- **Starship Prompt**: Minimal and full configurations with intelligent detection
- **ZSH Integration**: Native completion and syntax highlighting support
- **Performance Optimized**: Fast shell startup (< 0.5s)
- **Custom Functions**: Productivity shortcuts (tm, gq, jp, kcef)

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone <repository-url> ~/mini-sweet-home
cd ~/mini-sweet-home

# Install MSH system
make i
# or
./msh install

# Test installation
msh test
```

### System Installation (Recommended)

```bash
# Create symlink for system-wide access
ln -sf "$(pwd)/msh" ~/.local/bin/msh

# Now you can use msh from anywhere
msh status
msh test
```

## 📋 Commands

### **Installation & Setup**
```bash
msh install           # Install MSH with intelligent symlink management
msh reinstall         # Reinstall everything from scratch
msh clean             # Complete uninstall with backup restoration
msh uninstall         # Alias for clean
```

### **Testing & Validation**
```bash
msh test              # Run comprehensive system test
msh status            # Show detailed system status
msh debug-path        # Debug MSH directory detection
```

### **Utilities**
```bash
msh aliases           # Create convenient shell aliases
msh secrets           # Manage environment variables and API keys
```

### **Secrets Management**
```bash
msh secrets init      # Initialize secrets system
msh secrets edit      # Edit API keys and secrets
msh secrets show      # Display current secrets (masked)
msh secrets validate  # Validate .env file format
msh secrets backup    # Backup secrets to .env.backup
```

## 🔧 Configuration

### **Environment Variables**

Set custom MSH location:
```bash
export MSH_PROJECT_DIR="/custom/path/to/msh"
```

### **Secrets Setup**

1. Initialize secrets system:
```bash
msh secrets init
```

2. Edit your secrets:
```bash
msh secrets edit
```

3. Add to your shell profile:
```bash
# Already included in MSH zsh configuration
source ~/.env  # Automatic in MSH setups
```

## 🏗️ Architecture

```
mini-sweet-home/
├── msh                     # Main command entry point
├── Makefile               # Installation shortcuts
├── bin/                   # Utility scripts
│   ├── bulletproof-installer  # Multi-OS tool installer
│   ├── msh-secrets           # Secrets management
│   └── create-aliases        # Alias generator
├── lib/                   # Core modules
│   ├── core/
│   │   ├── install.sh        # Installation logic
│   │   ├── backup.sh         # Backup management
│   │   ├── clean.sh          # Cleanup utilities
│   │   ├── profile.sh        # Profile management
│   │   └── common.sh         # Common functions
│   ├── utils/
│   │   └── validation.sh     # Validation utilities
│   ├── fallbacks.sh          # Fallback configurations
│   └── testing.sh           # Test utilities
├── config/                # Configuration files
│   ├── shell/zsh/           # ZSH configurations
│   ├── starship/            # Starship prompt configs
│   └── [other configs...]
├── .env.template          # Secrets template
└── .gitignore            # Git ignore rules
```

## 🧪 Testing

MSH includes comprehensive testing:

```bash
# Quick test (recommended)
msh test

# Full system status
msh status

# Debug path detection
msh debug-path
```

**Test Results Include:**
- Shell startup performance (target: < 0.5s)
- Modern tools availability (8/8 tools)
- Function loading verification
- Individual tool validation

## 🐧 Multi-OS Support

### **Ubuntu/Debian**
```bash
# Automatic detection and installation
./msh install
```

### **Arch Linux**
```bash
# Enhanced AUR support with yay/paru
./msh install
```

See `ARCH_INSTALL.md` for detailed Arch Linux instructions.

## 🔍 Troubleshooting

### **Path Detection Issues**

1. **Check detection status:**
```bash
msh debug-path
```

2. **Set custom path:**
```bash
export MSH_PROJECT_DIR="/your/custom/path"
msh debug-path
```

3. **Validate installation:**
```bash
msh status
```

### **Common Issues**

**MSH directory not found:**
```bash
# Solution 1: Set environment variable
export MSH_PROJECT_DIR="/path/to/msh"

# Solution 2: Ensure standard location
mv /current/path ~/mini-sweet-home

# Solution 3: Create symlink
ln -sf "/path/to/msh/msh" ~/.local/bin/msh
```

**Tools not working:**
```bash
# Reinstall tools
msh reinstall

# Check individual tools
msh test
```

## 🎯 Performance

MSH v3.0 is optimized for performance:

- **Shell Startup**: < 0.5 seconds (excellent)
- **Tool Detection**: Cached and optimized
- **Memory Usage**: Minimal footprint
- **Load Time**: Lazy loading of modules

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly with `msh test`
5. Submit a pull request

## 📄 License

[Add your license information here]

## 🔗 Links

- **Documentation**: See individual config READMEs
- **Starship Config**: `config/starship/README.md`
- **Arch Linux**: `ARCH_INSTALL.md`

---

**MSH v3.0** - Professional Development Environment Management
*Built with ❤️ for developers who value performance and reliability*