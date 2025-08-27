# ================================================
# 🏠 MINI SWEET HOME - SMART ALIASES
# ================================================
# Aliases intelligents avec fallbacks automatiques

# ===============================
# 📁 NAVIGATION ALIASES
# ===============================

# ls/eza fallback with intelligent detection
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza -la --icons --tree --level=2'
else
    alias ls='ls --color=auto'
    alias ll='ls -la --color=auto'
    alias la='ls -la --color=auto'
    alias lt='ls -la --color=auto'
fi

# tree fallback: eza -> tree -> find
if command -v eza >/dev/null 2>&1; then
    alias tree='eza --tree --icons --level=3'
elif command -v tree >/dev/null 2>&1; then
    alias tree='tree -C -L 3'
else
    # Create tree function when no tree command exists
    # Note: using different approach to avoid alias conflicts
    alias tree='_tree_fallback'
    _tree_fallback() {
        local dir="${1:-.}"
        local level="${2:-3}"
        find "$dir" -type d -not -path '*/.*' | head -20 | sed -e 's/[^-][^\/]*\//  |/g' -e 's/|\([^ ]\)/|-\1/'
    }
fi

# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# ===============================
# 🔍 SEARCH & FIND ALIASES  
# ===============================

# Smart find with fd fallback
if command -v fd >/dev/null 2>&1; then
    alias ff='fd'
    alias find='fd'
else
    alias ff='find . -name'
fi

# Smart grep with ripgrep fallback
if command -v rg >/dev/null 2>&1; then
    alias grep='rg --color=always'
    alias search='rg -i'
else
    alias grep='grep --color=auto'
    alias search='grep -r -i'
fi

# ===============================
# 📝 EDITOR ALIASES
# ===============================

# Smart editor with nvim fallback
if command -v nvim >/dev/null 2>&1; then
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
    alias edit='nvim'
else
    alias v='vim'
    alias edit='vim'
fi

# Quick config edits
alias zshrc='$EDITOR ~/.zshrc'
alias vimrc='$EDITOR ~/.vimrc'
alias tmuxconf='$EDITOR ~/.tmux.conf'

# ===============================
# 📊 SYSTEM ALIASES
# ===============================

# Smart cat with bat fallback
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
    alias less='bat'
elif command -v batcat >/dev/null 2>&1; then  # Ubuntu package name
    alias cat='batcat --paging=never'
    alias less='batcat'
fi

# Smart disk usage with dust fallback
if command -v dust >/dev/null 2>&1; then
    alias du='dust'
    alias disk='dust'
else
    alias disk='du -h --max-depth=1'
fi

# Smart top with htop/btop fallback
if command -v btop >/dev/null 2>&1; then
    alias top='btop'
elif command -v htop >/dev/null 2>&1; then
    alias top='htop'
fi

# Process management
alias ps='ps aux'
alias psg='ps aux | grep'
alias kill='kill -9'

# ===============================
# 🐙 GIT ALIASES
# ===============================

# Core git shortcuts
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
alias gcb='git checkout -b'

# Advanced git aliases
alias gundo='git reset HEAD~1'
alias gclean='git clean -fd'
alias greset='git reset --hard'
alias gstash='git stash'
alias gpop='git stash pop'

# ===============================
# 🪟 TMUX ALIASES  
# ===============================

if command -v tmux >/dev/null 2>&1; then
    alias ta='tmux attach'
    alias tls='tmux list-sessions'
    alias tnew='tmux new-session'
    alias tkill='tmux kill-session'
    alias ide='tmux new-session -d -s dev && tmux split-window -h && tmux attach-session -t dev'
fi

# ===============================
# 📦 PACKAGE MANAGEMENT ALIASES
# ===============================

# Smart package management based on OS
if command -v apt >/dev/null 2>&1; then
    alias install='sudo apt install'
    alias update='sudo apt update && sudo apt upgrade'
    alias search='apt search'
    alias remove='sudo apt remove'
elif command -v brew >/dev/null 2>&1; then
    alias install='brew install'
    alias update='brew update && brew upgrade'
    alias search='brew search'
    alias remove='brew uninstall'
elif command -v dnf >/dev/null 2>&1; then
    alias install='sudo dnf install'
    alias update='sudo dnf update'
    alias search='dnf search'
    alias remove='sudo dnf remove'
elif command -v pacman >/dev/null 2>&1; then
    alias install='sudo pacman -S'
    alias update='sudo pacman -Syu'
    alias search='pacman -Ss'
    alias remove='sudo pacman -R'
fi

# ===============================
# 🌐 NETWORK ALIASES
# ===============================

alias ports='netstat -tuln'
alias ping='ping -c 5'
alias wget='wget -c'
alias curl='curl -L'

# IP information
alias myip='curl -s ifconfig.me'
alias localip='ip route get 1 | awk "{print \$NF; exit}"'

# ===============================
# 🧹 CLEANUP ALIASES
# ===============================

alias cleanup='sudo apt autoremove && sudo apt autoclean'
alias emptytrash='sudo rm -rf ~/.Trash/*'
alias clearlogs='sudo journalctl --vacuum-time=7d'

# ===============================
# 🚀 UTILITY ALIASES
# ===============================

# Quick shortcuts
alias reload='source ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'

# Safety nets
alias rm='rm -i'
alias cp='cp -i' 
alias mv='mv -i'
alias ln='ln -i'

# Make directories and cd into them
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives intelligently
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"  ;;
            *.rar)       unrar x "$1"  ;;
            *.gz)        gunzip "$1"   ;;
            *.tar)       tar xf "$1"   ;;
            *.tbz2)      tar xjf "$1"  ;;
            *.tgz)       tar xzf "$1"  ;;
            *.zip)       unzip "$1"    ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"     ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ===============================
# 📚 HELP & INFO ALIASES
# ===============================
alias aliases-help='echo "🏠 Mini Sweet Home Smart Aliases:
📁 Navigation: ls, ll, la, lt, tree (eza/exa/ls)
🔍 Search: ff, grep (fd/rg fallbacks)  
📝 Edit: v, vi, vim (nvim fallback)
📊 System: top, disk, cat (modern tools)
🐙 Git: g, ga, gc, gst, gp, gl
🪟 Tmux: ta, tls, tnew, ide
📦 Package: install, update, search
🚀 Tools auto-fallback to available alternatives!"'