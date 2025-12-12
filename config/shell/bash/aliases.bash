#!/bin/bash
# ===============================
# 🏠 MINI SWEET HOME - BASH ALIASES
# ===============================
# Identical to ZSH aliases for consistency

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
alias bashrc='nvim ~/.bashrc'
alias vimrc='nvim ~/.vimrc'

# ===============================
# 🐙 GIT ESSENTIELS (IDENTICAL TO ZSH)
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
alias gl='git log --oneline --graph'
alias gb='git branch'
alias gco='git checkout'
alias gcob='git checkout -b'

# Advanced git aliases
alias gundo='git reset HEAD~1'
alias gclean='git clean -fd'
alias greset='git reset --hard'
alias gstash='git stash'
alias gpop='git stash pop'

# Additional useful git aliases
alias gf='git fetch'
alias gm='git merge'
alias gr='git rebase'
alias gsh='git show'
alias gre='git remote -v'
alias gt='git tag'
alias glp='git log --pretty=format:"%h %s" --graph'

# Power user aliases
alias gwip='git add -A && git commit -m "WIP"'
alias gunwip='git log -n 1 | grep -q -c "WIP" && git reset HEAD~1'
alias gcp='git cherry-pick'
alias gmt='git mergetool'

# ===============================
# 🔧 SYSTEM ESSENTIELS
# ===============================
alias ps='ps aux'
alias psg='ps aux | grep'
alias ports='netstat -tuln'

# ===============================
# 🚀 PRODUCTIVITY
# ===============================
alias reload='source ~/.bashrc'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ===============================
# 🏠 MSH HELPERS
# ===============================
alias aliases='nvim ~/mini-sweet-home/config/shell/bash/aliases.bash'