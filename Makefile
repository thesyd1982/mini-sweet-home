# Aliases pour benchmarks
bench: benchmark
ben: benchmark

tools:
	@echo "🔧 Gestionnaire d'outils..."
	@./scripts/tools-manager

tools-status:
	@./scripts/tools-manager status

# Toggles rapides
tools-eza:
	@./scripts/tools-manager eza

tools-fd:
	@./scripts/tools-manager fd

tools-rg:
	@./scripts/tools-manager rg# ==========================================
# 🏠 MINI SWEET HOME - MAKEFILE ENHANCED
# ==========================================

.PHONY: help install minimal modern developer server update doctor backup test clean enhanced nvim benchmark
.DEFAULT_GOAL := help

# Couleurs
CYAN = \033[36m
GREEN = \033[32m
YELLOW = \033[33m
RESET = \033[0m

help: ## 🏠 Afficher cette aide
	@echo "$(CYAN)🏠 Mini Sweet Home - Installation modulaire$(RESET)"
	@echo "==============================================="
	@echo ""
	@echo "$(GREEN)Installation rapide (RECOMMANDÉ) :$(RESET)"
	@echo "  make enhanced   # Version améliorée avec auto-install Neovim"
	@echo ""
	@echo "$(GREEN)Installation classique :$(RESET)"
	@echo "  make install    # Menu interactif"
	@echo "  make minimal    # Configuration de base"
	@echo "  make modern     # Base + outils modernes"
	@echo "  make developer  # Environnement développeur complet"
	@echo "  make server     # Configuration serveur optimisée"
	@echo ""
	@echo "$(GREEN)Maintenance :$(RESET)"
	@echo "  make update     # Mettre à jour l'installation"
	@echo "  make doctor     # Diagnostic système"
	@echo "  make nvim       # Setup/update Neovim avec plugins"
	@echo "  make backup     # Sauvegarder les configs"
	@echo "  make benchmark  # Test de performance"
	@echo "  make test       # Tester l'installation"
	@echo "  make clean      # Nettoyer les fichiers temporaires"
	@echo ""
	@echo "$(YELLOW)💡 Nouveautés v2.1 :$(RESET)"
	@echo "  • Installation automatique des plugins Neovim"
	@echo "  • Commande msh améliorée"
	@echo "  • Support des lockfiles pour versions cohérentes"
	@echo "  • Installation des outils modernes optimisée"

enhanced: ## 🚀 Installation enhanced (RECOMMANDÉ)
	@echo "$(GREEN)🚀 Lancement de l'installation enhanced...$(RESET)"
	@chmod +x setup-enhanced
	@./setup-enhanced

install: ## 🚀 Installation interactive classique
	@echo "$(GREEN)🚀 Lancement de l'installation interactive...$(RESET)"
	@chmod +x setup
	@./setup

minimal: ## 🏃‍♂️ Installation minimale (configs de base)
	@echo "$(GREEN)🏃‍♂️ Installation profil minimal...$(RESET)"
	@chmod +x setup-enhanced
	@./setup-enhanced minimal

modern: ## ⚡ Installation moderne (minimal + outils CLI)
	@echo "$(GREEN)⚡ Installation profil modern...$(RESET)"
	@chmod +x setup-enhanced
	@./setup-enhanced modern

developer: ## 👩‍💻 Installation développeur (complet)
	@echo "$(GREEN)👩‍💻 Installation profil developer...$(RESET)"
	@chmod +x setup-enhanced
	@./setup-enhanced developer

server: ## 🖥️ Installation serveur (optimisée)
	@echo "$(GREEN)🖥️ Installation profil server...$(RESET)"
	@chmod +x setup-enhanced
	@./setup-enhanced server

nvim: ## 🚀 Setup/update Neovim avec plugins
	@echo "$(CYAN)🚀 Configuration Neovim avec plugins...$(RESET)"
	@if [ -f "$$HOME/.local/bin/msh" ]; then \
		$$HOME/.local/bin/msh nvim; \
	elif [ -f "scripts/setup-neovim.sh" ]; then \
		chmod +x scripts/setup-neovim.sh; \
		./scripts/setup-neovim.sh --headless; \
	else \
		echo "$(YELLOW)⚠️  Script Neovim non trouvé$(RESET)"; \
	fi

update: ## 🔄 Mettre à jour Mini Sweet Home
	@echo "$(CYAN)🔄 Mise à jour...$(RESET)"
	@if [ -f "$$HOME/.local/bin/msh" ]; then \
		$$HOME/.local/bin/msh update; \
	else \
		echo "$(YELLOW)⚠️  Mini Sweet Home non installé$(RESET)"; \
		echo "Exécutez 'make enhanced' d'abord"; \
	fi

doctor: ## 🩺 Diagnostic système
	@echo "$(CYAN)🩺 Diagnostic système...$(RESET)"
	@if [ -f "$$HOME/.local/bin/msh" ]; then \
		$$HOME/.local/bin/msh doctor; \
	else \
		echo "$(YELLOW)⚠️  Mini Sweet Home non installé$(RESET)"; \
		echo "Exécutez 'make enhanced' d'abord"; \
	fi

backup: ## 💾 Sauvegarder les configurations
	@echo "$(CYAN)💾 Sauvegarde...$(RESET)"
	@if [ -f "$$HOME/.local/bin/msh" ]; then \
		$$HOME/.local/bin/msh backup; \
	else \
		echo "$(YELLOW)⚠️  Sauvegarde manuelle...$(RESET)"; \
		mkdir -p ~/.mini-sweet-home-backup-$(shell date +%Y%m%d-%H%M%S); \
		cp ~/.zshrc ~/.mini-sweet-home-backup-$(shell date +%Y%m%d-%H%M%S)/ 2>/dev/null || true; \
		cp ~/.tmux.conf ~/.mini-sweet-home-backup-$(shell date +%Y%m%d-%H%M%S)/ 2>/dev/null || true; \
		cp ~/.gitconfig ~/.mini-sweet-home-backup-$(shell date +%Y%m%d-%H%M%S)/ 2>/dev/null || true; \
		echo "$(GREEN)✅ Sauvegarde terminée$(RESET)"; \
	fi

test: ## 🧪 Tester l'installation
	@echo "$(CYAN)🧪 Test de l'installation...$(RESET)"
	@echo "Vérification des composants :"
	@command -v zsh >/dev/null && echo "  ✅ ZSH" || echo "  ❌ ZSH"
	@command -v tmux >/dev/null && echo "  ✅ Tmux" || echo "  ❌ Tmux"
	@command -v nvim >/dev/null && echo "  ✅ Neovim" || echo "  ❌ Neovim"
	@command -v git >/dev/null && echo "  ✅ Git" || echo "  ❌ Git"
	@if [ -f ~/.zshrc ]; then echo "  ✅ Config ZSH"; else echo "  ❌ Config ZSH"; fi
	@if [ -f ~/.tmux.conf ]; then echo "  ✅ Config Tmux"; else echo "  ❌ Config Tmux"; fi
	@if [ -f ~/.gitconfig ]; then echo "  ✅ Config Git"; else echo "  ❌ Config Git"; fi
	@if [ -d ~/.config/nvim ]; then echo "  ✅ Config Neovim"; else echo "  ❌ Config Neovim"; fi
	@echo ""
	@echo "Outils modernes :"
	@command -v dust >/dev/null && echo "  ✅ dust" || echo "  ⚠️  dust (optionnel)"
	@command -v rg >/dev/null && echo "  ✅ ripgrep" || echo "  ⚠️  ripgrep (optionnel)"
	@command -v fd >/dev/null && echo "  ✅ fd" || echo "  ⚠️  fd (optionnel)"
	@command -v bat >/dev/null && echo "  ✅ bat" || echo "  ⚠️  bat (optionnel)"
	@command -v exa >/dev/null && echo "  ✅ exa" || echo "  ⚠️  exa (optionnel)"
	@command -v starship >/dev/null && echo "  ✅ starship" || echo "  ⚠️  starship (optionnel)"
	@command -v zoxide >/dev/null && echo "  ✅ zoxide" || echo "  ⚠️  zoxide (optionnel)"
	@echo ""
	@echo "Plugins Neovim :"
	@if [ -d ~/.local/share/nvim/lazy ]; then \
		PLUGIN_COUNT=$$(find ~/.local/share/nvim/lazy -maxdepth 1 -type d 2>/dev/null | wc -l); \
		echo "  ✅ $$((PLUGIN_COUNT - 1)) plugins installés"; \
	else \
		echo "  ⚠️  Aucun plugin trouvé"; \
	fi

clean: ## 🧹 Nettoyer les fichiers temporaires
	@echo "$(YELLOW)🧹 Nettoyage...$(RESET)"
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@rm -f tmux-*.log 2>/dev/null || true
	@rm -f /tmp/nvim_install*.lua 2>/dev/null || true
	@echo "$(GREEN)✅ Nettoyage terminé$(RESET)"

status: ## 📊 Afficher le statut du système
	@echo "$(CYAN)📊 Statut Mini Sweet Home$(RESET)"
	@echo "========================="
	@echo ""
	@if [ -f "$$HOME/.local/bin/msh" ]; then \
		echo "$(GREEN)✅ Mini Sweet Home installé$(RESET)"; \
		$$HOME/.local/bin/msh doctor; \
	else \
		echo "$(YELLOW)⚠️  Mini Sweet Home non installé$(RESET)"; \
		echo "Exécutez 'make enhanced' pour installer"; \
	fi

benchmark: ## 🚀 Lancer le benchmark de performance
	@echo "$(CYAN)🚀 Benchmark de performance...$(RESET)"
	@chmod +x scripts/benchmark
	@./scripts/benchmark

demo: ## 🎯 Démonstration rapide
	@echo "$(CYAN)🎯 Démonstration Mini Sweet Home Enhanced$(RESET)"
	@echo "=========================================="
	@echo ""
	@echo "1. Installation rapide RECOMMANDÉE :"
	@echo "   make enhanced"
	@echo ""
	@echo "2. Profils disponibles :"
	@echo "   • minimal    - Configuration de base + Neovim avec plugins"
	@echo "   • modern     - Base + outils CLI modernes (dust, rg, fd, bat, exa)"
	@echo "   • developer  - Environnement développeur (+ Node.js, LSP servers)"
	@echo "   • server     - Configuration serveur optimisée"
	@echo ""
	@echo "3. Nouveautés v2.1 :"
	@echo "   • Installation automatique des plugins Neovim"
	@echo "   • Commande msh améliorée avec plus de fonctionnalités"
	@echo "   • Support des lockfiles pour versions cohérentes"
	@echo "   • Optimisations performance"
	@echo ""
	@echo "4. Test rapide :"
	@echo "   make test"

# Aliases rapides
i: install ## 🚀 Alias pour install
e: enhanced ## 🚀 Alias pour enhanced (RECOMMANDÉ)
m: modern ## ⚡ Alias pour modern
d: developer ## 👩‍💻 Alias pour developer
s: status ## 📊 Alias pour status
t: test ## 🧪 Alias pour test
n: nvim ## 🚀 Alias pour nvim
b: benchmark ## 🚀 Alias pour benchmark
