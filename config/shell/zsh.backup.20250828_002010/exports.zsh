#!/usr/bin/env zsh
# ===============================
# 🏠 MINI SWEET HOME - EXPORTS
# ===============================
# Minimaliste, rapide, zéro dépendance externe

# ===============================
# 🛤️ PATH ESSENTIELS
# ===============================
export PATH="$HOME/mini-sweet-home/bin:$HOME/bin:/usr/local/bin:$HOME/.local/bin:/usr/local/go/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# ===============================
# 🌍 ENVIRONNEMENT DE BASE
# ===============================
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'
export LANG=en_US.UTF-8
export KEYTIMEOUT=1

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
# 🚀 OPENCODE INTEGRATION
# ===============================
export PATH=/home/thesyd/.opencode/bin:$PATH
export FUNCNEST=1000