#!/usr/bin/env zsh
# ===============================
# 🏠 MINI SWEET HOME - EXPORTS
# ===============================
# Minimaliste, rapide, zéro dépendance externe

# ===============================
# 🛤️ PATH ESSENTIELS
# ===============================
export PATH="$HOME/mini-sweet-home/bin:$HOME/bin:/usr/local/bin:$HOME/.local/bin:/usr/local/go/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.cargo/bin"
export PATH="$HOME/.local/bin:$PATH"
# ===============================
# 🌍 ENVIRONNEMENT DE BASE
# ===============================
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'
export LANG=en_US.UTF-8
export KEYTIMEOUT=1
# ===============================
#  ENVIRONNEMENT LOCAL
# ===============================
[ -f ~/.config/secrets.env ] && source ~/.config/secrets.env

# ===============================
# 📚 HISTORIQUE OPTIMISÉ
# ===============================
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000
export SAVEHIST=1000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# ===============================
# 🐚 ZSH OPTIONS ESSENTIELS
# ===============================
setopt AUTO_CD
setopt CORRECT
setopt NO_CASE_GLOB
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END

# ===============================
# ⌨️ VI MODE & KEYBINDINGS
# ===============================
bindkey -v
bindkey '^r' history-incremental-search-backward
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# Quick shortcuts
bindkey -s '^[r' "source ~/.zshrc\n"
bindkey -s '^[g' "clear\n"

# ===============================
# 🧠 COMPLÉTION RAPIDE
# ===============================
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ===============================
# 🎨 HIGHLIGHTING SIMPLE
# ===============================
[[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && 
    source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ===============================
# 🚀 AUTOSUGGESTIONS (RÉACTIVÉES)
# ===============================
if [[ -f ~/.zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
    # Compatibility with vi mode
    bindkey '^[[Z' autosuggest-accept  # Shift-Tab to accept suggestion
fi

# ===============================
# 🚀 OPENCODE INTEGRATION
# ===============================
export PATH=/home/thesyd/.opencode/bin:$PATH
export FUNCNEST=1000
# ===============================
# 🔐 SECRETS MANAGEMENT
# ===============================
# Load environment variables from .env file (gitignored)
MSH_ENV_FILE="$HOME/mini-sweet-home/.env"
if [[ -f "$MSH_ENV_FILE" ]]; then
    # Use set -a to automatically export variables, then source the file
    set -a
    source "$MSH_ENV_FILE" 2>/dev/null || {
        # Fallback: manual parsing if source fails
        while IFS='=' read -r key value || [[ -n "$key" ]]; do
            # Skip comments and empty lines
            [[ "$key" =~ ^[[:space:]]*# ]] && continue
            [[ -z "${key// }" ]] && continue
            
            # Clean key and value
            key=$(echo "$key" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
            value=$(echo "$value" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
            
            # Export if valid variable name
            if [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] && [[ -n "$value" ]]; then
                export "$key"="$value"
            fi
        done < "$MSH_ENV_FILE"
    }
    set +a
else
    # Warn if .env doesn't exist but template does
    if [[ -f "$HOME/mini-sweet-home/.env.template" ]]; then
        echo "⚠️  MSH: .env file not found. Copy .env.template to .env and configure your secrets."
    fi
fi
