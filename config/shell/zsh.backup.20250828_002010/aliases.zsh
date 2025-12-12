#!/usr/bin/env zsh
# ===============================
# 🏠 MINI SWEET HOME - ALIASES
# ===============================
# Essentiels uniquement, zéro complexité

# ===============================
# 📁 NAVIGATION DE BASE
# ===============================
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias la='ls -la --color=auto'
alias lt='ls -la --color=auto'

# Navigation rapide
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ===============================
# 📝 ÉDITION RAPIDE
# ===============================
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias edit='nvim'

# Config shortcuts
alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/.config/nvim/init.lua'

# ===============================
# 🐙 GIT ESSENTIELS
# ===============================
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gst='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch'
alias gco='git checkout'

# ===============================
# 🖥️ TMUX SIMPLE
# ===============================
alias ta='tmux attach'
alias tls='tmux list-sessions'
alias tnew='tmux new-session'

# ===============================
# 🔧 UTILITAIRES
# ===============================
alias reload='source ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'
alias cls='clear'

# Sécurité
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ===============================
# 📚 AIDE
# ===============================
alias help='echo "🏠 Mini Sweet Home Aliases:
📁 Navigation: ls, ll, la, .., ..., ~
📝 Edit: v, vi, vim (→ nvim)
🐙 Git: g, ga, gc, gp, gst, gl, gb
🖥️ Tmux: ta, tls, tnew
🔧 Utils: reload, path, cls
🚀 Project: sp (project switcher)"'