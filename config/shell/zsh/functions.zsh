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
# 📁 NAVIGATION FUNCTION (jp - NETTOYÉ)
# ===============================
jp() {
    if [[ $# -eq 0 ]]; then
        cd ~
    else
        # Recherche manuelle simple (plus de zoxide)
        local dirs=(~/*"$1"* ~/"$1"*)
        for dir in "${dirs[@]}"; do
            if [[ -d "$dir" ]]; then
                cd "$dir"
                echo "✅ Found: $dir" 
                return 0
            fi
        done
        echo "No match found for: $@"
        return 1
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
# 🏢 KCE PROJECT FUNCTION (kcef - NETTOYÉ)
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
    
    # Recherche directe (plus de zoxide)
    for path in "${paths[@]}"; do
        if [[ -d $path ]]; then
            cd "$path"
            echo "✅ Trouvé: $path"
            return 0
        fi
    done
    
    echo "❌ Projet non trouvé. Chemins testés:"
    printf '  - %s\n' "${paths[@]}"
    echo "💡 Naviguez manuellement vers le projet pour l'ajouter aux chemins"
    return 1
}

# Alias pour compatibilité
alias kce='kcef'
alias gerasso='kcef'

# ===============================
# 🚀 NVM LAZY LOADING
# ===============================
# Clear any pre-existing NVM functions and variables
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
# 💡 HELP SYSTEM (NETTOYÉ)
# ===============================
commands() {
    echo -e "\033[0;34m🚀 DOTFILES V4 - COMMANDS DISPONIBLES:\033[0m"
    echo ""
    echo -e "\033[0;32m📁 Navigation:\033[0m"
    echo "  jp <query>        - Jump to project"
    echo "  jj <query>        - Alias for jp"
    echo "  kcef              - Go to KCE/Gerasso project"
    echo "  take <dir>        - Create directory and cd into it"
    echo "  back [n]          - Go back n directories (default: 1)"
    echo ""
    echo -e "\033[0;32m🪟 Tmux:\033[0m"
    echo "  tm new [name]     - Create/attach session"
    echo "  tm list           - List sessions"
    echo "  tm attach [name]  - Attach to session"
    echo "  tm kill [name]    - Kill session"
    echo ""
    echo -e "\033[0;32m⚡ Git Quick:\033[0m"
    echo "  gq s              - git status"
    echo "  gq a              - git add ."
    echo "  gq c 'msg'        - git commit -m"
    echo "  gq p              - git push"
    echo "  gq pl             - git pull"
    echo ""
    echo -e "\033[0;32m🚀 Node.js (Lazy):\033[0m"
    echo "  nvm               - Node Version Manager (auto-loads)"
    echo "  npm               - Node Package Manager (auto-loads)"
    echo "  npx               - Execute Node packages (auto-loads)"
    echo "  node              - Node.js runtime (auto-loads)"
    echo ""
    echo -e "\033[0;32m🏠 Shortcuts:\033[0m"
    echo "  Alt+R             - Reload .zshrc"
    echo "  Alt+G             - Clear terminal"
    echo "  Ctrl+R            - Search history"
    echo "  ..                - cd .."
    echo "  ...               - cd ../.."
    echo ""
}

# Aliases directs pour les fonctions utiles
alias take='take_function'
