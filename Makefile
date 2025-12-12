# MSH v3.0 - Makefile
# Simple and useful shortcuts

.PHONY: install test status clean help
.DEFAULT_GOAL := help

# Colors
CYAN = \033[36m
GREEN = \033[32m
YELLOW = \033[33m
NC = \033[0m

help: ## 🏠 Show this help
	@echo "$(CYAN)🚀 MSH v3.0 - Mini Sweet Home$(NC)"
	@echo "$(CYAN)Professional Development Environment$(NC)"
	@echo "════════════════════════════════════════════════════"
	@echo ""
	@echo "$(GREEN)Main Commands:$(NC)"
	@echo "  make install    - Install MSH with bulletproof tools"  
	@echo "  make test       - Test your installation"
	@echo "  make status     - Check system status"
	@echo "  make aliases    - Create convenient shell aliases"
	@echo ""
	@echo "$(GREEN)Shortcuts:$(NC)"
	@echo "  make i          - Alias for install"
	@echo "  make t          - Alias for test" 
	@echo "  make s          - Alias for status"
	@echo "  make a          - Alias for aliases"
	@echo ""
	@echo "$(GREEN)Maintenance:$(NC)"
	@echo "  make clean      - Clean temporary files"
	@echo "  make backup     - Create backup"
	@echo ""
	@echo "$(YELLOW)💡 Or use directly: ./msh install$(NC)"

install: ## 🚀 Install MSH with all tools
	@echo "$(GREEN)🚀 Installing MSH v3.0...$(NC)"
	@./msh install

test: ## 🧪 Test your installation
	@echo "$(CYAN)🧪 Testing MSH...$(NC)"
	@./msh test

status: ## 📊 Show system status  
	@echo "$(BLUE)📊 Checking status...$(NC)"
	@./msh status

clean: ## 🧹 Clean temporary files
	@echo "$(YELLOW)🧹 Cleaning...$(NC)"
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@rm -rf /tmp/*msh* /tmp/*eza* /tmp/*fzy* 2>/dev/null || true
	@echo "$(GREEN)✅ Cleaned$(NC)"

aliases: ## 🔗 Create convenient shell aliases
	@echo "$(BLUE)🔗 Creating aliases...$(NC)"
	@./msh aliases

backup: ## 💾 Create backup
	@echo "$(CYAN)💾 Creating backup...$(NC)"
	@tar czf "msh-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz" \
		bin/ lib/ config/ msh Makefile 2>/dev/null || true
	@echo "$(GREEN)✅ Backup created$(NC)"

# Convenient aliases
i: install ## 🚀 Alias for install
t: test    ## 🧪 Alias for test  
s: status  ## 📊 Alias for status
a: aliases ## 🔗 Alias for aliases