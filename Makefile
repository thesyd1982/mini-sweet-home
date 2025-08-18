# ===============================
# 🏠 MINI SWEET HOME - MAKEFILE
# ===============================

.PHONY: help install test check deps clean update backup
.DEFAULT_GOAL := help

# Colors for output
CYAN = \033[36m
GREEN = \033[32m
YELLOW = \033[33m
RED = \033[31m
RESET = \033[0m

# Variables
DOTFILES_DIR := $(HOME)/mini-sweet-home
TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

help: ## 🏠 Show this help message
	@echo "$(CYAN)🏠 Mini Sweet Home - Cozy Development Environment$(RESET)"
	@echo "=================================================="
	@echo ""
	@echo "$(GREEN)Usage: make [target]$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(YELLOW)💡 Quick start: make install && make check$(RESET)"

install: ## 🚀 Install Mini Sweet Home with all dependencies
	@echo "$(GREEN)🚀 Installing Mini Sweet Home...$(RESET)"
	@chmod +x install bin/dependency-manager bin/benchmark
	@./install
	@echo "$(GREEN)✅ Installation complete! Run 'exec zsh' to start.$(RESET)"

quick: ## ⚡ Quick install (configs only, no dependency check)
	@echo "$(YELLOW)⚡ Quick installation (configs only)...$(RESET)"
	@chmod +x bin/*
	@ln -sf "$(DOTFILES_DIR)/configs/shell/zsh/zshrc" ~/.zshrc
	@ln -sf "$(DOTFILES_DIR)/configs/tmux/tmux.conf" ~/.tmux.conf
	@ln -sf "$(DOTFILES_DIR)/configs/git/gitconfig" ~/.gitconfig
	@rm -rf ~/.config/nvim && ln -sf "$(DOTFILES_DIR)/configs/nvim" ~/.config/nvim
	@echo "$(GREEN)✅ Quick installation complete!$(RESET)"

check: ## 🔍 Check dependency status
	@echo "$(CYAN)🔍 Checking dependencies...$(RESET)"
	@./bin/dependency-manager check

deps: ## 📦 Install missing dependencies
	@echo "$(GREEN)📦 Installing missing dependencies...$(RESET)"
	@./bin/dependency-manager install-missing

deps-all: ## 📦 Install all dependencies (full setup)
	@echo "$(GREEN)📦 Installing all dependencies...$(RESET)"
	@./bin/dependency-manager install-all

rust: ## 🦀 Install Rust toolchain
	@echo "$(GREEN)🦀 Installing Rust...$(RESET)"
	@./bin/dependency-manager install-rust

go: ## 🐹 Install Go toolchain
	@echo "$(GREEN)🐹 Installing Go...$(RESET)"
	@./bin/dependency-manager install-go

nodejs: ## 🐹 Install Node.js
	@echo "$(GREEN)🐹 Installing Node.js...$(RESET)"
	@./bin/dependency-manager install-nodejs

python: ## 🐍 Install Python
	@echo "$(GREEN)🐍 Installing Python...$(RESET)"
	@./bin/dependency-manager install-python

docker: ## 🐳 Install Docker
	@echo "$(GREEN)🐳 Installing Docker...$(RESET)"
	@./bin/dependency-manager install-docker

neovim: ## 📝 Install/Update Neovim
	@echo "$(GREEN)📝 Installing Neovim...$(RESET)"
	@./bin/dependency-manager install-neovim

modern: ## ⚡ Install modern CLI tools
	@echo "$(GREEN)⚡ Installing modern CLI tools...$(RESET)"
	@./bin/dependency-manager install-modern

test: ## 🧪 Run tests
	@echo "$(CYAN)🧪 Running tests...$(RESET)"
	@chmod +x tests/test-*
	@./tests/test-installation
	@./tests/test-configs
	@echo "$(GREEN)✅ All tests passed!$(RESET)"

test-quick: ## ⚡ Run quick test suite
	@echo "$(CYAN)⚡ Running quick tests...$(RESET)"
	@chmod +x bin/test-runner
	@./bin/test-runner quick

test-standard: ## 🧪 Run standard test suite
	@echo "$(CYAN)🧪 Running standard tests...$(RESET)"
	@chmod +x bin/test-runner
	@./bin/test-runner standard

test-minimal: ## ⚡ Run minimal test suite
	@echo "$(CYAN)⚡ Running minimal tests...$(RESET)"
	@chmod +x bin/test-runner
	@./bin/test-runner minimal

verify: ## 🔍 Complete system verification
	@echo "$(CYAN)🔍 Running complete verification...$(RESET)"
	@chmod +x bin/verify
	@./bin/verify

tmux-toggle: ## 🎨 Toggle between fast/full tmux configs
	@echo "$(CYAN)🎨 Toggling tmux configuration...$(RESET)"
	@chmod +x bin/tmux-speed-toggle
	@./bin/tmux-speed-toggle

benchmark: ## 📊 Run performance benchmark
	@echo "$(CYAN)📊 Running performance benchmark...$(RESET)"
	@./bin/benchmark

backup: ## 💾 Backup current configs
	@echo "$(YELLOW)💾 Creating backup...$(RESET)"
	@mkdir -p ~/.dotfiles_backup_$(TIMESTAMP)
	@cp ~/.zshrc ~/.dotfiles_backup_$(TIMESTAMP)/ 2>/dev/null || true
	@cp ~/.tmux.conf ~/.dotfiles_backup_$(TIMESTAMP)/ 2>/dev/null || true
	@cp ~/.gitconfig ~/.dotfiles_backup_$(TIMESTAMP)/ 2>/dev/null || true
	@cp -r ~/.config/nvim ~/.dotfiles_backup_$(TIMESTAMP)/ 2>/dev/null || true
	@echo "$(GREEN)✅ Backup created: ~/.dotfiles_backup_$(TIMESTAMP)$(RESET)"

update: ## 🔄 Update Mini Sweet Home to latest version
	@echo "$(CYAN)🔄 Updating Mini Sweet Home...$(RESET)"
	@git pull origin main
	@make backup
	@make install
	@echo "$(GREEN)✅ Update complete!$(RESET)"

clean: ## 🧹 Clean up temporary files
	@echo "$(YELLOW)🧹 Cleaning up...$(RESET)"
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@echo "$(GREEN)✅ Cleanup complete!$(RESET)"

uninstall: ## ❌ Uninstall Mini Sweet Home (restore backups)
	@echo "$(RED)❌ Uninstalling Mini Sweet Home...$(RESET)"
	@echo "$(YELLOW)⚠️  This will restore your previous configs$(RESET)"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		latest_backup=$$(ls -1d ~/.dotfiles_backup_* 2>/dev/null | tail -1); \
		if [ -n "$$latest_backup" ]; then \
			echo "$(CYAN)Restoring from: $$latest_backup$(RESET)"; \
			cp $$latest_backup/.zshrc ~/ 2>/dev/null || true; \
			cp $$latest_backup/.tmux.conf ~/ 2>/dev/null || true; \
			cp $$latest_backup/.gitconfig ~/ 2>/dev/null || true; \
			rm -rf ~/.config/nvim && cp -r $$latest_backup/nvim ~/.config/ 2>/dev/null || true; \
			echo "$(GREEN)✅ Configs restored$(RESET)"; \
		else \
			echo "$(YELLOW)⚠️  No backup found, removing symlinks only$(RESET)"; \
			rm -f ~/.zshrc ~/.tmux.conf ~/.gitconfig; \
			rm -rf ~/.config/nvim; \
		fi; \
		echo "$(GREEN)✅ Uninstallation complete$(RESET)"; \
	else \
		echo "$(CYAN)Cancelled.$(RESET)"; \
	fi

status: ## 📊 Show system status
	@echo "$(CYAN)📊 Mini Sweet Home Status$(RESET)"
	@echo "=========================="
	@echo ""
	@echo "$(GREEN)📁 Installation:$(RESET)"
	@if [ -d "$(DOTFILES_DIR)" ]; then echo "  ✅ Mini Sweet Home installed"; else echo "  ❌ Not installed"; fi
	@if [ -L ~/.zshrc ]; then echo "  ✅ ZSH config linked"; else echo "  ❌ ZSH not linked"; fi
	@if [ -L ~/.tmux.conf ]; then echo "  ✅ Tmux config linked"; else echo "  ❌ Tmux not linked"; fi
	@if [ -L ~/.config/nvim ]; then echo "  ✅ Neovim config linked"; else echo "  ❌ Neovim not linked"; fi
	@echo ""
	@echo "$(GREEN)🛠️  Core Tools:$(RESET)"
	@command -v zsh >/dev/null && echo "  ✅ ZSH" || echo "  ❌ ZSH missing"
	@command -v tmux >/dev/null && echo "  ✅ Tmux" || echo "  ❌ Tmux missing"  
	@command -v nvim >/dev/null && echo "  ✅ Neovim" || echo "  ❌ Neovim missing"
	@command -v git >/dev/null && echo "  ✅ Git" || echo "  ❌ Git missing"
	@echo ""
	@echo "$(GREEN)⚡ Modern Tools:$(RESET)"
	@command -v exa >/dev/null && echo "  ✅ exa" || echo "  ⚠️  exa (fallback: ls)"
	@command -v bat >/dev/null && echo "  ✅ bat" || echo "  ⚠️  bat (fallback: cat)"
	@command -v fd >/dev/null && echo "  ✅ fd" || echo "  ⚠️  fd (fallback: find)"
	@command -v rg >/dev/null && echo "  ✅ ripgrep" || echo "  ⚠️  ripgrep (fallback: grep)"
	@echo ""
	@echo "$(YELLOW)💡 Run 'make check' for detailed dependency status$(RESET)"

doctor: ## 🩺 Diagnose issues and suggest fixes
	@echo "$(CYAN)🩺 Mini Sweet Home Doctor$(RESET)"
	@echo "=========================="
	@echo ""
	@./bin/dependency-manager check
	@echo ""
	@echo "$(GREEN)🔧 Suggested actions:$(RESET)"
	@if ! command -v nvim >/dev/null; then echo "  💊 Run: make neovim"; fi
	@if ! command -v cargo >/dev/null; then echo "  💊 Run: make rust"; fi
	@if ! command -v exa >/dev/null; then echo "  💊 Run: make modern"; fi
	@if ! [ -d ~/.zsh-syntax-highlighting ]; then echo "  💊 Run: make deps"; fi
	@echo "  💊 Run: make benchmark (check performance)"
	@echo "  💊 Run: make test (verify installation)"

info: ## ℹ️ Show system information
	@echo "$(CYAN)ℹ️  System Information$(RESET)"
	@echo "====================="
	@echo "$(GREEN)OS:$(RESET) $$(uname -s) $$(uname -r)"
	@echo "$(GREEN)Arch:$(RESET) $$(uname -m)"
	@echo "$(GREEN)Shell:$(RESET) $$SHELL"
	@echo "$(GREEN)Terminal:$(RESET) $$TERM"
	@echo "$(GREEN)Home:$(RESET) $$HOME"
	@echo "$(GREEN)User:$(RESET) $$USER"
	@echo ""
	@if command -v lsb_release >/dev/null 2>&1; then \
		echo "$(GREEN)Distribution:$(RESET) $$(lsb_release -d | cut -f2)"; \
	elif [ -f /etc/os-release ]; then \
		echo "$(GREEN)Distribution:$(RESET) $$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"; \
	fi

# Development targets
dev-setup: ## 🔧 Setup development environment
	@echo "$(GREEN)🔧 Setting up development environment...$(RESET)"
	@make deps-all
	@make test
	@make benchmark

dev-test: ## 🧪 Run development tests
	@echo "$(CYAN)🧪 Running development tests...$(RESET)"
	@shellcheck install bin/* 2>/dev/null || echo "$(YELLOW)⚠️  shellcheck not available$(RESET)"
	@make test

# Quick aliases for common tasks
i: install ## 🚀 Alias for install
c: check ## 🔍 Alias for check  
t: test ## 🧪 Alias for test
b: benchmark ## 📊 Alias for benchmark
s: status ## 📊 Alias for status
q: quick-check ## ⚡ Alias for quick-check
h: health ## 🩸 Alias for health

# Additional utility targets
quick-check: ## ⚡ Quick validation before commit
	@echo "$(CYAN)⚡ Running quick validation...$(RESET)"
	@chmod +x bin/quick-check
	@./bin/quick-check

health: ## 🩸 Check system health
	@echo "$(CYAN)🩸 Checking system health...$(RESET)"
	@chmod +x bin/health-check
	@./bin/health-check

health-watch: ## 🔄 Monitor system health continuously
	@echo "$(CYAN)🔄 Starting health monitoring...$(RESET)"
	@chmod +x bin/health-check
	@./bin/health-check --watch
