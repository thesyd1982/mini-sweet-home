# ===============================
# 🚀 DOTFILES V4 - FUNCTIONS
# ===============================

# ===============================
# 🛡️ UTILITY FUNCTIONS
# ===============================

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ===============================
# 📁 NAVIGATION FUNCTION (jp pour éviter conflit avec zoxide)
# ===============================
# Note: zoxide utilise déjà 'j', on utilise 'jp' (jump project)
jp() {
    if [[ $# -eq 0 ]]; then
        cd ~
    else
        local result=$(zoxide query "$@" 2>/dev/null)
        if [[ -n "$result" ]]; then
            cd "$result"
        else
            echo "No match found for: $@"
            return 1
        fi
    fi
}

# Alias alternatif
alias jj='jp'

# ===============================
# 📁 DIRECTORY UTILITIES
# ===============================
# Function for 'take' alias - create directory and cd into it
take_function() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: take <directory_name>"
        return 1
    fi
    
    mkdir -p "$1" && cd "$1"
    echo "✅ Created and entered: $1"
}

# Quick directory back navigation
back() {
    local num="${1:-1}"
    local path=""
    for ((i=1; i<=num; i++)); do
        path="../$path"
    done
    cd "$path"
}

# ===============================
# 🪟 TMUX SESSION MANAGER (tm)
# ===============================
tm() {
    case "$1" in
        new|n)
            local session_name="${2:-$(basename $(pwd))}"
            if tmux has-session -t "$session_name" 2>/dev/null; then
                echo "Session '$session_name' already exists. Attaching..."
                tmux attach-session -t "$session_name"
            else
                echo "Creating new session: $session_name"
                tmux new-session -d -s "$session_name"
                tmux attach-session -t "$session_name"
            fi
            ;;
        list|ls|l)
            tmux list-sessions
            ;;
        attach|a)
            if [[ -n "$2" ]]; then
                tmux attach-session -t "$2"
            else
                tmux attach-session
            fi
            ;;
        kill|k)
            if [[ -n "$2" ]]; then
                tmux kill-session -t "$2"
            else
                echo "Usage: tm kill <session_name>"
            fi
            ;;
        *)
            echo "Usage: tm {new [name]|list|attach [name]|kill <name>}"
            echo "  new [name]    - Create new session (default: current dir name)"
            echo "  list          - List all sessions"
            echo "  attach [name] - Attach to session"
            echo "  kill <name>   - Kill session"
            ;;
    esac
}

# ===============================
# ⚡ GIT QUICK COMMANDS (gq)
# ===============================
gq() {
    case "$1" in
        s|status)
            git status
            ;;
        a|add)
            git add .
            echo "All changes staged"
            ;;
        c|commit)
            if [[ -n "$2" ]]; then
                git commit -m "$2"
            else
                echo "Usage: gq c 'commit message'"
            fi
            ;;
        p|push)
            git push
            ;;
        pl|pull)
            git pull
            ;;
        *)
            echo "Usage: gq {s|a|c 'message'|p|pl}"
            echo "  s  - git status"
            echo "  a  - git add ."
            echo "  c  - git commit -m"
            echo "  p  - git push"
            echo "  pl - git pull"
            ;;
    esac
}

# ===============================
# 🏢 KCE PROJECT FUNCTION (kcef)
# ===============================
kcef() {
    echo "🏢 Navigation vers projet KCE/Gerasso..."
    
    # Chemins étendus basés sur votre usage
    local paths=(
        ~/projects/asso*
        ~/business/asso*
        ~/depotkce*
        ~/projects/gerasso*
        ~/business/gerasso*
        ~/projects/kce*
        ~/work/kce*
        ~/asso*
        ~/gerasso*
        ~/kce*
    )
    
    # Tentative avec zoxide d'abord
    if command -v zoxide >/dev/null 2>&1; then
        local zoxide_results=(
            $(zoxide query asso 2>/dev/null)
            $(zoxide query gerasso 2>/dev/null)
            $(zoxide query kce 2>/dev/null)
        )
        
        for result in "${zoxide_results[@]}"; do
            if [[ -n "$result" && -d "$result" ]]; then
                cd "$result"
                echo "✅ Trouvé via zoxide: $result"
                return 0
            fi
        done
    fi
    
    # Fallback avec recherche étendue
    for path in "${paths[@]}"; do
        if [[ -d $path ]]; then
            cd "$path"
            echo "✅ Trouvé: $path"
            
            # Ajout à zoxide pour la prochaine fois
            command -v zoxide >/dev/null && zoxide add "$path"
            return 0
        fi
    done
    
    echo "❌ Projet non trouvé. Chemins testés:"
    printf '  - %s\n' "${paths[@]}"
    echo "💡 Naviguez manuellement une fois, puis utilisez 'j' pour l'ajouter à zoxide"
    return 1
}

# Alias pour compatibilité
alias kce='kcef'
alias gerasso='kcef'

# ===============================
# 🚀 NVM LAZY LOADING
# ===============================
# Clear any existing NVM environment to ensure lazy loading
unset NVM_DIR NVM_LOADED 2>/dev/null

# Load NVM with priority over system Node
load_nvm() {
    if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        
        # Add NVM to PATH with PRIORITY
        if [[ -n "$(nvm current 2>/dev/null)" ]]; then
            export PATH="$NVM_DIR/versions/node/$(nvm current)/bin:$PATH"
        fi
        
        if [[ -s "$NVM_DIR/bash_completion" ]]; then
            source "$NVM_DIR/bash_completion"
        fi
        
        # Mark as loaded
        export NVM_LOADED=true
    fi
}

# Lazy loading functions
nvm() {
    if [[ "$NVM_LOADED" != "true" ]]; then
        unset -f nvm npm node npx 2>/dev/null
        load_nvm
    fi
    command nvm "$@"
}

npm() {
    if [[ "$NVM_LOADED" != "true" ]]; then
        unset -f nvm npm node npx 2>/dev/null
        load_nvm
    fi
    command npm "$@"
}

npx() {
    if [[ "$NVM_LOADED" != "true" ]]; then
        unset -f nvm npm node npx 2>/dev/null
        load_nvm
    fi
    command npx "$@"
}

node() {
    if [[ "$NVM_LOADED" != "true" ]]; then
        unset -f nvm npm node npx 2>/dev/null
        load_nvm
    fi
    command node "$@"
}

# ===============================
# 📦 MODULES IMPORT
# ===============================
# Load modular components for better maintainability
# TEMPORARILY DISABLED - Loading project-switcher corrupts shell environment
# source "${0:A:h}/modules/project-switcher.zsh"

# Manual loading function instead of automatic
load_project_switcher() {
    if [[ -z "$PS_MODULE_LOADED" ]]; then
        local module_path="${HOME}/mini-sweet-home/configs/shell/zsh/modules/project-switcher.zsh"
        if [[ -f "$module_path" ]]; then
            source "$module_path"
            # Ensure aliases are created
            alias sp='project_switch'
            alias project='project_switch'
            export PS_MODULE_LOADED=1
            echo "✅ Project Switcher loaded manually"
        else
            echo "❌ Project Switcher module not found: $module_path"
            return 1
        fi
    else
        echo "⚠️ Project Switcher already loaded"
    fi
}

# Alternative: Load on demand (ACTIVE)
alias sp='load_project_switcher >/dev/null 2>&1 && project_switch'

# ===============================
# 💡 HELP SYSTEM
# ===============================
commands() {
    echo -e "\033[0;34m🚀 DOTFILES V4 - COMMANDS DISPONIBLES:\033[0m"
    echo ""
    echo -e "\033[0;32m📁 Navigation:\033[0m"
    echo "  j <query>         - Navigate with zoxide"
    echo "  jp <query>        - Jump to project (no conflict)"
    echo "  jj <query>        - Alias for jp"
    echo "  kcef              - Go to KCE/Gerasso project"
    echo "  sp                - Project switcher with auto tmux (fd powered)"
    echo "  spd               - Project switcher debug mode"
    echo ""
    echo -e "\033[0;32m🪟 Tmux:\033[0m"
    echo "  tm new [name]     - Create/attach session"
    echo "  tm list           - List sessions"
    echo "  tm attach [name]  - Attach to session"
    echo "  tm kill <name>    - Kill session"
    echo ""
    echo -e "\033[0;32m⚡ Git:\033[0m"
    echo "  gst, gaa, gcm     - Git status, add all, commit"
    echo "  gq s/a/c/p/pl     - Quick git commands"
    echo "  gco <branch>      - Git checkout"
    echo ""
    echo -e "\033[0;32m🚀 Development:\033[0m"
    echo "  node, npm, nvm    - Lazy loaded (fast startup)"
    echo "  v, vi, vim        - nvim"
    echo "  vzc               - Edit zsh config"
    echo "  vnv               - Edit nvim config"
    echo ""
    echo -e "\033[0;32m🛠️ Shortcuts:\033[0m"
    echo "  c                 - clear"
    echo "  ll                - exa -la (modern ls)"
    echo "  commands          - Show this help"
    echo ""
}

# ===============================
# 🌳 HELPER FUNCTIONS FOR GIT ALIASES
# ===============================
# Note: Ces fonctions sont nécessaires pour les alias Git OH-MY-ZSH
# Elles sont déplacées ici depuis aliases.zsh pour une meilleure organisation

# Get main branch name
git_main_branch() {
    command git rev-parse --git-dir &>/dev/null || return
    local ref
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
        if command git show-ref -q --verify $ref; then
            echo ${ref:t}
            return
        fi
    done
    echo master
}

# Get develop branch name
git_develop_branch() {
    command git rev-parse --git-dir &>/dev/null || return
    local branch
    for branch in dev devel development; do
        if command git show-ref -q --verify refs/heads/$branch; then
            echo $branch
            return
        fi
    done
    echo develop
}

# Alias pour compatibilité
alias help='commands'
alias h='commands'
