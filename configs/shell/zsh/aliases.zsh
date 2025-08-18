# ===============================
# 🏠 MINI SWEET HOME - ALIASES INTELLIGENTS
# ===============================

# ===============================
# 🛡️ SMART TOOL DETECTION & FALLBACKS
# ===============================

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Smart ls replacement (exa -> ls fallback)
if command_exists exa; then
    alias ls='exa --color=always --group-directories-first'
    alias ll='exa -la --color=always --group-directories-first'
    alias la='exa -a --color=always --group-directories-first'
    alias lt='exa -T --color=always --group-directories-first'
    alias tree='exa -T --color=always --group-directories-first'
    alias l='exa -l'
    alias lall='exa -la'
    alias lh='exa -lah'
    alias ltime='exa -lt modified'
    alias lr='exa -lR'
else
    # Fallback to traditional ls with colors
    if ls --color=auto >/dev/null 2>&1; then
        alias ls='ls --color=auto'
        alias ll='ls -la --color=auto'
        alias la='ls -a --color=auto'
    else
        alias ls='ls -G'  # macOS
        alias ll='ls -la -G'
        alias la='ls -a -G'
    fi
    alias lt='ls -la'
    alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'
    alias l='ls -l'
    alias lall='ls -la'
    alias lh='ls -lah'
    alias ltime='ls -lat'
    alias lr='ls -lR'
fi

# Smart cat replacement (bat -> cat fallback)
if command_exists bat; then
    alias cat='bat --paging=never'
    alias ccat='cat'  # Original cat for piping
elif command_exists batcat; then  # Ubuntu package name
    alias cat='batcat --paging=never'
    alias ccat='cat'
else
    alias ccat='cat'  # Keep original
fi

# Smart file search (fd -> find fallback)
if command_exists fd; then
    alias ff='fd'
    alias find_files='fd'
elif command_exists fdfind; then  # Ubuntu package name
    alias ff='fdfind'
    alias find_files='fdfind'
else
    alias ff='find . -name'
    alias find_files='find . -name'
fi

# Smart grep (rg -> grep fallback)
if command_exists rg; then
    alias grep='rg'
    alias grepr='rg'
    alias search='rg -i'
else
    alias grep='grep --color=auto'
    alias grepr='grep -r --color=auto'
    alias search='grep -ri'
fi

# Smart disk usage (dust -> du fallback)
if command_exists dust; then
    alias du='dust'
    alias disk='dust'
    alias dush='dust -d 1'
else
    alias disk='du -h --max-depth=1 2>/dev/null || du -h -d 1'
    alias dush='du -sh'
fi

# Smart process viewer (btop -> htop -> top fallback)
if command_exists btop; then
    alias top='btop'
    alias htop='btop'
elif command_exists htop; then
    alias top='htop'
else
    # Keep default top
    :
fi

# Smart cd with zoxide fallback
if command_exists zoxide; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdi='zi'  # Interactive mode
    alias cdd='cd'  # Original cd
else
    alias cdi='cd'  # No interactive mode available
    alias cdd='cd'
fi

# ===============================
# 📝 EDITOR DETECTION & FALLBACKS
# ===============================
if command_exists nvim; then
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
    alias nano='nvim'
    alias edit='nvim'
elif command_exists vim; then
    alias v='vim'
    alias vi='vim'
    alias edit='vim'
    alias nano='vim'
elif command_exists vi; then
    alias v='vi'
    alias vim='vi'
    alias edit='vi'
    alias nano='vi'
else
    alias v='nano'
    alias vi='nano'
    alias vim='nano'
    alias edit='nano'
fi

# ===============================
# ⚡ MINI SWEET HOME SPECIFIC
# ===============================
alias bench='benchmark'
alias vzc='$EDITOR ~/mini-sweet-home/configs/shell/zsh/zshrc'
alias vnv='$EDITOR ~/.config/nvim'
alias vtm='$EDITOR ~/mini-sweet-home/configs/tmux/tmux.conf'
alias vgit='$EDITOR ~/mini-sweet-home/configs/git/gitconfig'
alias valiases='$EDITOR ~/mini-sweet-home/configs/shell/zsh/aliases.zsh'
alias vfunctions='$EDITOR ~/mini-sweet-home/configs/shell/zsh/functions.zsh'

# Neovim with MCP (if available)
if command_exists nvim; then
    alias nvim-mcp='nvim --listen 0.0.0.0:6666'
fi

# ===============================
# 📁 SMART NAVIGATION
# ===============================
alias c='clear'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Directory operations with smart defaults
alias md='mkdir -p'
alias rd='rmdir'
alias mkd='mkdir -p'

# File operations with confirmations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# System information with smart tools
alias df='df -h'
alias free='free -h'

# Quick file viewing with smart pagination
if command_exists less; then
    alias less='less -R'
fi

alias head='head -n 20'
alias tail='tail -n 20'

# Archive operations
alias tarx='tar -xvf'
alias tarc='tar -cvf'
if command_exists unzip; then
    alias unzip='unzip -q'
fi

# Permission shortcuts
alias chmodx='chmod +x'
alias perm644='chmod 644'
alias perm755='chmod 755'

# ===============================
# 🐙 GIT ALIASES (ESSENTIAL ONLY)
# ===============================
if command_exists git; then
    # Basic Git commands
    alias g='git'
    alias ga='git add'
    alias gaa='git add --all'
    alias gc='git commit -v'
    alias gcm='git commit -m'
    alias gco='git checkout'
    alias gcb='git checkout -b'
    alias gst='git status'
    alias gss='git status -s'
    alias gl='git pull'
    alias gp='git push'
    alias gb='git branch'
    alias gd='git diff'
    alias glog='git log --oneline --decorate --graph'
    alias glola='git log --graph --pretty=format:"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --all'
fi

# ===============================
# 🪟 TMUX SMART ALIASES
# ===============================
if command_exists tmux; then
    alias tls='tmux list-sessions'
    alias ta='tmux attach -t'
    alias tnew='tmux new-session -s'
    alias tkill='tmux kill-session -t'
    
    # Custom scripts (if they exist)
    if [[ -f "$HOME/tmux-changer.sh" ]]; then
        alias tmux-style='~/tmux-changer.sh'
        alias tstyle='~/tmux-changer.sh'
        alias tmc='~/tmux-changer.sh'
    fi
    
    alias ide='tmux split-window -h && tmux split-window -v && tmux select-pane -t 0 && tmux split-window -v'
fi

# ===============================
# 🛠️ SYSTEM SHORTCUTS
# ===============================
alias reload='source ~/.zshrc'
alias zshrc='$EDITOR ~/.zshrc'

# Network shortcuts with smart tools
if command_exists ping; then
    alias ping='ping -c 5'
fi

if command_exists curl; then
    alias myip='curl -s ifconfig.me'
    alias weather='curl wttr.in'
    alias cheat='curl cheat.sh'
fi

# System information with smart fallbacks
if command_exists neofetch; then
    alias sysinfo='neofetch'
elif command_exists screenfetch; then
    alias sysinfo='screenfetch'
else
    alias sysinfo='uname -a; uptime; df -h'
fi

alias diskspace='df -h'
alias meminfo='free -h'

if command_exists lscpu; then
    alias cpuinfo='lscpu'
elif [[ -f /proc/cpuinfo ]]; then
    alias cpuinfo='cat /proc/cpuinfo'
fi

# ===============================
# 🐳 DOCKER (IF AVAILABLE)
# ===============================
if command_exists docker; then
    alias d='docker'
    alias dps='docker ps'
    alias di='docker images'
    alias dex='docker exec -it'
    alias drm='docker rm'
    alias drmi='docker rmi'
    alias dprune='docker system prune'
fi

if command_exists docker-compose; then
    alias dc='docker-compose'
elif command_exists docker; then
    alias dc='docker compose'  # New syntax
fi

# ===============================
# 📦 PACKAGE MANAGER DETECTION
# ===============================
if command_exists apt; then
    alias install='sudo apt install'
    alias update='sudo apt update'
    alias upgrade='sudo apt upgrade'
    alias search='apt search'
elif command_exists dnf; then
    alias install='sudo dnf install'
    alias update='sudo dnf update'
    alias upgrade='sudo dnf upgrade'
    alias search='dnf search'
elif command_exists pacman; then
    alias install='sudo pacman -S'
    alias update='sudo pacman -Sy'
    alias upgrade='sudo pacman -Syu'
    alias search='pacman -Ss'
elif command_exists brew; then
    alias install='brew install'
    alias update='brew update'
    alias upgrade='brew upgrade'
    alias search='brew search'
fi

# ===============================
# 📋 PRODUCTIVITY
# ===============================
alias week='date +%V'
alias path='echo $PATH | tr ":" "\n"'
alias env='env | sort'

# Development shortcuts
if command_exists python3; then
    alias serve='python3 -m http.server 8000'
elif command_exists python; then
    alias serve='python -m http.server 8000'
fi

if command_exists jq; then
    alias json='jq .'
fi

# ===============================
# 📋 CLIPBOARD (IF AVAILABLE)
# ===============================
if command_exists xclip; then
    alias copy='xclip -selection clipboard'
    alias paste='xclip -selection clipboard -o'
elif command_exists pbcopy; then  # macOS
    alias copy='pbcopy'
    alias paste='pbpaste'
fi

# ===============================
# 🔧 DEVELOPMENT TOOLS
# ===============================

# Node.js tools (if available)
if command_exists npm; then
    alias ni='npm install'
    alias nr='npm run'
    alias ns='npm start'
    alias nt='npm test'
fi

if command_exists yarn; then
    alias y='yarn'
    alias ya='yarn add'
    alias yr='yarn run'
fi

# Rust tools (if available)
if command_exists cargo; then
    alias cr='cargo run'
    alias cb='cargo build'
    alias ct='cargo test'
    alias cc='cargo check'
fi

# Go tools (if available)
if command_exists go; then
    alias gr='go run'
    alias gb='go build'
    alias gt='go test'
    alias gm='go mod'
fi

# ===============================
# 🎨 FUN EXTRAS
# ===============================
if command_exists fortune; then
    alias quote='fortune'
fi

if command_exists cowsay; then
    alias cow='cowsay'
fi

# ===============================
# 📊 SMART ALIASES INFO
# ===============================
alias aliases-help='echo "🏠 Mini Sweet Home Smart Aliases:
📁 Navigation: ls, ll, la, lt, tree (exa/ls)
🔍 Search: ff, grep (fd/rg fallbacks)  
📝 Edit: v, vi, vim (nvim fallback)
📊 System: top, disk, cat (modern tools)
🐙 Git: g, ga, gc, gst, gp, gl
🪟 Tmux: ta, tls, tnew, ide
📦 Package: install, update, search
🚀 Tools auto-fallback to available alternatives!"'
