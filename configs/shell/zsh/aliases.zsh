# ===============================
# 🚀 DOTFILES V4 - ALIASES
# ===============================

# ===============================
# 📝 EDITORS
# ===============================
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vzc='nvim ~/dotfiles/configs/shell/zsh/zshrc'
alias vnv='nvim ~/.config/nvim'
alias vtm='nvim ~/dotfiles/configs/tmux/tmux.conf'
alias vgit='nvim ~/dotfiles/configs/git/gitconfig'
alias valiases='nvim ~/dotfiles/configs/shell/zsh/aliases.zsh'
alias vfunctions='nvim ~/dotfiles/configs/shell/zsh/functions.zsh'
alias nvim-mcp='nvim --listen 0.0.0.0:6666'

# ===============================
# 📁 NAVIGATION & FILES
# ===============================
# Modern file listing
alias ls='exa --color=always --group-directories-first'
alias ll='exa -la --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias lt='exa -T --color=always --group-directories-first'
alias tree='exa -T --color=always --group-directories-first'

# Quick navigation
alias c='clear'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Directory operations
alias md='mkdir -p'
alias rd='rmdir'
alias mkd='mkdir -p'
alias take='take_function'

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Quick file viewing
alias cat='bat'
alias less='less -R'
alias head='head -n 20'
alias tail='tail -n 20'
alias top='btop'

# Quick file editing
alias nano='nvim'
alias edit='nvim'

# Directory listing shortcuts
alias l='exa -l'
alias lall='exa -la'
alias lh='exa -lah'
alias ltime='exa -lt modified'
alias lr='exa -lR'

# File search
alias f='find . -name'
alias ff='fd'

# Archive operations
alias tarx='tar -xvf'
alias tarc='tar -cvf'
alias unzip='unzip -q'

# Permission shortcuts
alias chmodx='chmod +x'
alias perm644='chmod 644'
alias perm755='chmod 755'

# ===============================
# 🐙 GIT ALIASES (OH-MY-ZSH COMPLETE)
# ===============================
# Basic Git
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias gap='git apply'
alias gapt='git apply --3way'

# Branch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^(\\+|\\*|\\s*($(git_main_branch)|$(git_develop_branch))\\s*$)" | command xargs -n 1 git branch -d'
alias gbD='git branch -D'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# Commit
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcam='git commit -a -m'
alias gcas='git commit -a -s'
alias gcasm='git commit -a -s -m'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recurse-submodules'
alias gclean='git clean -id'
alias gcm='git commit -m'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'
alias gcsm='git commit -s -m'
alias gcss='git commit -S -s'
alias gcssm='git commit -S -s -m'

# Diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'

# Fetch
alias gfetch='git fetch'
alias gfo='git fetch origin'

# Log
alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'

# Merge
alias gm='git merge'
alias gmom='git merge origin/$(git_main_branch)'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/$(git_main_branch)'

# Push/Pull
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpu='git push upstream'
alias gpv='git push -v'
alias gpl='git pull'
alias gpr='git pull --rebase'
alias gprv='git pull --rebase -v'
alias gpra='git pull --rebase --autostash'
alias gprav='git pull --rebase --autostash -v'

# Rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase develop'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'

# Remote
alias gr='git remote'
alias gra='git remote add'
alias grh='git reset'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_main_branch) --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'

# Stash
alias gst='git status'
alias gss='git status -s'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='git stash --include-untracked'
alias gstall='git stash --all'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch -c'

# Tag
alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'

# Working tree
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

# What changed
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'

# ===============================
# 🪟 TMUX
# ===============================
alias tls='tmux list-sessions'
alias ta='tmux attach -t'
alias tmux-style='~/tmux-changer.sh'    # Dynamic tmux status changer
alias tstyle='~/tmux-changer.sh'       # Short alias
alias tmc='~/tmux-changer.sh'          # Tmux changer
alias ide='tmux split-window -h && tmux split-window -v && tmux select-pane -t 0 && tmux split-window -v'

# ===============================
# 🛠️ SYSTEM SHORTCUTS
# ===============================
# System shortcuts
alias reload='source ~/.zshrc'
alias zshrc='nvim ~/.zshrc'
alias hosts='sudo nvim /etc/hosts'
alias ssh-config='nvim ~/.ssh/config'

# Process management
alias ps='ps aux'
alias kill9='kill -9'
alias pgrep='pgrep -l'
alias jobs='jobs -l'

# Network shortcuts
alias ping='ping -c 5'
alias myip='curl -s ifconfig.me'
alias localip='ip route get 1.1.1.1 | awk "{print \$7}"'
alias ports='netstat -tuln'

# System information
alias sysinfo='neofetch'
alias diskspace='df -h'
alias meminfo='free -h'
alias cpuinfo='lscpu'

# Development shortcuts
alias serve='python3 -m http.server 8000'
alias json='jq .'
alias weather='curl wttr.in'
alias cheat='curl cheat.sh'

# ===============================
# 🐳 DOCKER SHORTCUTS
# ===============================
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dex='docker exec -it'

# ===============================
# 📁 NAVIGATION SHORTCUTS
# ===============================
alias home='cd ~'
alias root='cd /'
alias downloads='cd ~/Downloads'
alias docs='cd ~/Documents'

# ===============================
# 📦 PACKAGE MANAGER (Ubuntu/Debian)
# ===============================
alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias search='apt search'

# ===============================
# 📋 FILE OPERATIONS
# ===============================
alias backup='cp -r'
alias size='du -sh'
alias disk='dust 2>/dev/null'
alias count='find . -type f | wc -l'

# ===============================
# 📋 CLIPBOARD OPERATIONS
# ===============================
alias copy='xclip -selection clipboard'
alias paste='xclip -selection clipboard -o'

# ===============================
# ⏰ PRODUCTIVITY
# ===============================
alias bench='~/dotfiles/bin/benchmark'  # Benchmark dotfiles performance
alias week='date +%V'
alias path='echo $PATH | tr ":" "\n"'
alias env='env | sort'
