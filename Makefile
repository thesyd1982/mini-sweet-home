# MSH v3.0 - Makefile
# Simple and useful shortcuts

.PHONY: install test status clean help
.DEFAULT_GOAL := help

# Colors (using printf for better compatibility)
# CYAN = \033[36m | GREEN = \033[32m | YELLOW = \033[33m | BLUE = \033[34m | NC = \033[0m

help: ## 🏠 Show this help
	@printf "\033[36m🚀 MSH v3.0 - Mini Sweet Home\033[0m\n"
	@printf "\033[36mProfessional Development Environment\033[0m\n"
	@echo "════════════════════════════════════════════════════"
	@echo ""
	@printf "\033[32mMain Commands:\033[0m\n"
	@echo "  make install    - Install MSH with bulletproof tools"  
	@echo "  make test       - Test your installation"
	@echo "  make status     - Check system status"
	@echo "  make aliases    - Create convenient shell aliases"
	@echo ""
	@printf "\033[32mShortcuts:\033[0m\n"
	@echo "  make i          - Alias for install"
	@echo "  make t          - Alias for test" 
	@echo "  make s          - Alias for status"
	@echo "  make a          - Alias for aliases"
	@echo ""
	@printf "\033[32mMaintenance:\033[0m\n"
	@echo "  make clean      - Clean temporary files"
	@echo "  make backup     - Create backup"
	@echo ""
	@printf "\033[33m💡 Or use directly: ./msh install\033[0m\n"

install: ## 🚀 Install MSH with all tools
	@printf "\033[32m🚀 Installing MSH v3.0...\033[0m\n"
	@echo "1" | ./msh install

test: ## 🧪 Test your installation
	@printf "\033[36m🧪 Testing MSH...\033[0m\n"
	@./msh test

status: ## 📊 Show system status  
	@printf "\033[34m📊 Checking status...\033[0m\n"
	@./msh status

clean: ## 🧹 Clean temporary files
	@printf "\033[33m🧹 Cleaning...\033[0m\n"
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@rm -rf /tmp/*msh* /tmp/*eza* /tmp/*fzy* 2>/dev/null || true
	@printf "\033[32m✅ Cleaned\033[0m\n"

aliases: ## 🔗 Create convenient shell aliases
	@printf "\033[34m🔗 Creating aliases...\033[0m\n"
	@./msh aliases

backup: ## 💾 Create backup
	@printf "\033[36m💾 Creating backup...\033[0m\n"
	@tar czf "msh-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz" \
		bin/ lib/ config/ msh Makefile 2>/dev/null || true
	@printf "\033[32m✅ Backup created\033[0m\n"

# Convenient aliases
i: install ## 🚀 Alias for install
t: test    ## 🧪 Alias for test  
s: status  ## 📊 Alias for status
a: aliases ## 🔗 Alias for aliases