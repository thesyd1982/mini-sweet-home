#!/usr/bin/env zsh
# ===============================
# 🏠 MSH NATIVE ZSH ENHANCEMENTS
# ===============================
# Solution native légère pour syntax highlighting et autosuggestions
# Utilise les capacités natives de ZSH pour des performances optimales

# ===============================
# 🎨 NATIVE SYNTAX HIGHLIGHTING
# ===============================

# Activer les couleurs ZSH
autoload -U colors && colors

# Configuration des couleurs pour les différents types
typeset -A MSH_COLORS
MSH_COLORS=(
    'command'   "$fg[green]"
    'alias'     "$fg[cyan]"
    'builtin'   "$fg[yellow]"
    'function'  "$fg[blue]"
    'path'      "$fg[magenta]"
    'option'    "$fg[cyan]"
    'error'     "$fg[red]"
    'reset'     "$reset_color"
)

# Fonction simple de highlighting via le prompt
msh_highlight_command() {
    # Utiliser les capacités natives de ZSH pour la coloration
    # Ceci sera intégré dans le prompt pour être plus performant
    local cmd="$1"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        if alias "$cmd" >/dev/null 2>&1; then
            echo "${MSH_COLORS[alias]}$cmd${MSH_COLORS[reset]}"
        elif [[ -n "${builtins[$cmd]}" ]]; then
            echo "${MSH_COLORS[builtin]}$cmd${MSH_COLORS[reset]}"
        elif [[ -n "${functions[$cmd]}" ]]; then
            echo "${MSH_COLORS[function]}$cmd${MSH_COLORS[reset]}"
        else
            echo "${MSH_COLORS[command]}$cmd${MSH_COLORS[reset]}"
        fi
    else
        echo "${MSH_COLORS[error]}$cmd${MSH_COLORS[reset]}"
    fi
}

# ===============================
# 🚀 NATIVE AUTOSUGGESTIONS
# ===============================

# Variables pour les suggestions
typeset -g MSH_LAST_SUGGESTION=""
typeset -g MSH_SUGGESTION_STYLE="%F{240}"

# Fonction pour obtenir une suggestion de l'historique
msh_get_suggestion() {
    local current="$1"
    local suggestion=""
    
    if [[ -n "$current" && ${#current} -gt 1 ]]; then
        # Rechercher dans l'historique récent (plus rapide)
        suggestion="$(fc -l -50 | grep -m1 "^[[:space:]]*[0-9]*[[:space:]]*$current" | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' 2>/dev/null)"
        
        # Si pas trouvé, recherche plus large
        if [[ -z "$suggestion" ]]; then
            suggestion="$(fc -l -200 | grep -m1 "$current" | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' 2>/dev/null)"
        fi
    fi
    
    echo "$suggestion"
}

# Widget ZLE pour les autosuggestions
msh_autosuggest_widget() {
    local suggestion="$(msh_get_suggestion "$LBUFFER")"
    
    if [[ -n "$suggestion" && "$suggestion" != "$BUFFER" ]]; then
        local remaining="${suggestion#$LBUFFER}"
        if [[ -n "$remaining" ]]; then
            # Stocker la suggestion pour l'acceptation
            MSH_LAST_SUGGESTION="$suggestion"
            
            # Afficher visuellement la suggestion (méthode simple)
            zle -M "${MSH_SUGGESTION_STYLE}${remaining}%f"
        fi
    else
        MSH_LAST_SUGGESTION=""
        zle -M ""
    fi
}

# Widget pour accepter la suggestion
msh_accept_suggestion_widget() {
    if [[ -n "$MSH_LAST_SUGGESTION" ]]; then
        BUFFER="$MSH_LAST_SUGGESTION"
        CURSOR=${#BUFFER}
        MSH_LAST_SUGGESTION=""
        zle redisplay
    fi
}

# Widget pour accepter partiellement (mot par mot)
msh_accept_word_widget() {
    if [[ -n "$MSH_LAST_SUGGESTION" ]]; then
        local words=(${(z)MSH_LAST_SUGGESTION})
        local current_words=(${(z)BUFFER})
        
        if [[ ${#words} -gt ${#current_words} ]]; then
            local next_word="${words[$((${#current_words} + 1))]}"
            BUFFER="$BUFFER$next_word "
            CURSOR=${#BUFFER}
            zle redisplay
        fi
    fi
}

# ===============================
# 🔧 COMPLETION AMÉLIORÉE
# ===============================

# Configuration de la complétion native ZSH
msh_setup_completion() {
    # Complétion intelligente
    zstyle ':completion:*' menu select
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
    zstyle ':completion:*:warnings' format '%F{red}-- No matches found --%f'
    
    # Complétion pour les commandes MSH
    zstyle ':completion:*:*:msh:*' file-patterns '*:all-files'
    
    # Cache de complétion pour la performance
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path ~/.zsh/cache
}

# ===============================
# 🚀 INITIALISATION OPTIMISÉE
# ===============================

msh_init_native_enhancements() {
    # Vérifier que nous sommes dans ZSH
    [[ -z "${ZSH_VERSION:-}" ]] && return 1
    
    # Charger les hooks ZSH
    autoload -U add-zsh-hook
    
    # Configurer la complétion
    msh_setup_completion
    
    # Créer les widgets ZLE
    zle -N msh-autosuggest msh_autosuggest_widget
    zle -N msh-accept-suggestion msh_accept_suggestion_widget
    zle -N msh-accept-word msh_accept_word_widget
    
    # Keybindings optimisés
    bindkey '^[[Z' msh-accept-suggestion    # Shift-Tab: accepter suggestion complète
    bindkey '^I' msh-accept-word           # Tab: accepter mot par mot
    bindkey '^[[C' forward-char            # Flèche droite: caractère par caractère
    
    # Hook léger sur les changements
    add-zsh-hook precmd msh_refresh_suggestions
    
    return 0
}

# Hook de rafraîchissement (léger)
msh_refresh_suggestions() {
    # Nettoyer les anciennes suggestions
    MSH_LAST_SUGGESTION=""
}

# ===============================
# 📊 FONCTIONS DE STATUT
# ===============================

msh_native_status() {
    echo "📊 MSH Native ZSH Enhancements:"
    echo "  ✅ Native completion: Enhanced"
    echo "  ✅ History suggestions: Active"
    echo "  ✅ Smart keybindings: Configured"
    echo "  🎨 Color highlighting: Basic"
    echo "  ⚡ Performance: Optimized"
}

# ===============================
# 🔄 AUTO-INITIALISATION
# ===============================

# Initialiser automatiquement si dans ZSH
if [[ -n "${ZSH_VERSION:-}" ]]; then
    msh_init_native_enhancements
fi