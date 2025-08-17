# Makefile pour Dotfiles V4

.PHONY: install test bench push pull sync backup clean help

# Installation par défaut
install:
	@echo "🏠 Installation Mini Sweet Home..."
	@./install

# Installation avec profils
minimal:
	@./install minimal

developer:
	@./install developer

devops:
	@./install devops

complete:
	@./install complete

# Tests
test:
	@echo "🧪 Lancement des tests..."
	@chmod +x tests/*
	@./tests/test-installation
	@./tests/test-configs

# Benchmark performance
bench:
	@echo "🚀 Benchmark des performances..."
	@chmod +x bin/benchmark
	@./bin/benchmark

# Synchronisation Git
push:
	@echo "📤 Push des changements..."
	@git add .
	@git status
	@echo "Commit message: "; read msg; git commit -m "$msg"
	@git push origin main

pull:
	@echo "📥 Pull des changements..."
	@git pull origin main

sync:
	@echo "🔄 Synchronisation complète..."
	@git add .
	@git status
	@echo "Commit message: "; read msg; git commit -m "$msg"
	@git push origin main
	@echo "✅ Synchronisation terminée"

# Sauvegarde
backup:
	@echo "💾 Sauvegarde des configurations..."
	@chmod +x bin/backup-configs
	@./bin/backup-configs

# Analyse
analyze:
	@./install --analyze

# Nettoyage
clean:
	@echo "🧹 Nettoyage des sauvegardes anciennes..."
	@find ~ -maxdepth 1 -name ".dotfiles_backup_*" -type d -mtime +30 -exec rm -rf {} \;

# Aide
help:
	@echo "📋 Commandes disponibles:"
	@echo "  make install     - Installation minimale"
	@echo "  make developer   - Installation développeur"
	@echo "  make devops      - Installation DevOps"
	@echo "  make complete    - Installation complète"
	@echo "  make test        - Tester l'installation"
	@echo "  make bench       - Benchmark des performances"
	@echo "  make push        - Commit et push"
	@echo "  make pull        - Pull des changements"
	@echo "  make sync        - Synchronisation complète"
	@echo "  make backup      - Sauvegarder les configs"
	@echo "  make analyze     - Analyser la config actuelle"
	@echo "  make clean       - Nettoyer anciennes sauvegardes"
	@echo "  make help        - Afficher cette aide"
