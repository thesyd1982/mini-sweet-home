#!/usr/bin/env zsh
# ==============================================
# 🏗️ PROJECT SWITCHER - CONFIGURATION SYSTEM
# ==============================================

# Configuration globales
declare -g PS_CONFIG_DIR="${HOME}/.config/mini-sweet-home"
declare -g PS_CONFIG_FILE="${PS_CONFIG_DIR}/config.yaml"
declare -g PS_DATA_DIR="${HOME}/.local/share/mini-sweet-home"
declare -g PS_CACHE_DIR="${HOME}/.cache/mini-sweet-home"

# Configuration par défaut en mémoire
declare -gA PS_CONFIG=(
    # Meta
    [config_version]="2.0"
    [user_profile]="default"
    
    # Discovery
    [discovery.max_depth]="3"
    [discovery.parallel_scan]="true"
    [discovery.max_results]="100"
    
    # UI
    [ui.theme]="default"
    [ui.show_icons]="true"
    [ui.show_project_types]="true"
    [ui.show_paths]="true"
    [ui.quiet_mode]="false"
    [ui.debug_mode]="false"
    [ui.show_progress]="true"
    [ui.progress_style]="spinner"
    
    # Colors
    [ui.colors.debug]="magenta"
    [ui.colors.info]="cyan"
    [ui.colors.success]="green"
    [ui.colors.warning]="yellow"
    [ui.colors.error]="red"
    
    # Keybindings
    [keybindings.style]="default"
    [keybindings.fzf.select]="enter"
    [keybindings.fzf.open_vscode]="ctrl-o"
    [keybindings.fzf.open_vim]="ctrl-v"
    [keybindings.fzf.refresh]="ctrl-r"
    [keybindings.fzf.cancel]="esc"
    
    # TMUX
    [tmux.enabled]="true"
    [tmux.auto_create_session]="true"
    [tmux.session.name_template]="\${project_name}"
    [tmux.session.sanitize_names]="true"
    [tmux.layout.default]="main-horizontal"
    [tmux.layout.split_horizontal]="true"
    [tmux.layout.split_vertical]="true"
    [tmux.panes.auto_split]="true"
    [tmux.panes.split_layout]="horizontal"
    
    # Integrations
    [integrations.editors.vscode.command]="code"
    [integrations.editors.vscode.enabled]="true"
    [integrations.editors.neovim.command]="nvim"
    [integrations.editors.neovim.enabled]="true"
    [integrations.tools.zoxide.enabled]="true"
    [integrations.tools.zoxide.auto_add]="true"
    [integrations.tools.zoxide.command]="j"
    [integrations.tools.git.show_status]="true"
    [integrations.tools.git.show_branch]="true"
    
    # Performance
    [performance.cache.enabled]="true"
    [performance.cache.ttl]="3600"
    [performance.scanning.parallel]="true"
    [performance.scanning.max_workers]="4"
    [performance.scanning.timeout]="30"
    [performance.lazy_loading]="true"
    [performance.preload_common]="true"
    
    # Analytics
    [analytics.enabled]="true"
    [analytics.store_usage]="true"
    [analytics.history.max_recent]="50"
    [analytics.history.max_bookmarks]="20"
    [analytics.history.auto_bookmark_frequent]="true"
    [analytics.history.frequency_threshold]="5"
    
    # Logging
    [logging.level]="info"
    [logging.rotate]="true"
    [logging.max_size]="10MB"
    [logging.max_files]="5"
)

# Arrays de configuration
declare -ga PS_CONFIG_SEARCH_PATHS
declare -ga PS_CONFIG_EXCLUDE_PATTERNS
declare -ga PS_CONFIG_ENABLED_DETECTORS
declare -gA PS_CONFIG_DETECTORS

# ==============================================
# 📖 YAML PARSER SIMPLE
# ==============================================
_ps_parse_yaml() {
    local yaml_file="$1"
    [[ ! -f "$yaml_file" ]] && return 1
    
    local current_section=""
    local in_list=false
    local list_key=""
    
    # Reset arrays
    PS_CONFIG_SEARCH_PATHS=()
    PS_CONFIG_EXCLUDE_PATTERNS=()
    PS_CONFIG_ENABLED_DETECTORS=()
    
    while IFS= read -r line; do
        # Ignorer commentaires et lignes vides
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "${line// }" ]] && continue
        
        # Calculer indentation
        local indent_count=0
        local temp_line="$line"
        while [[ "$temp_line" == " "* ]]; do
            temp_line="${temp_line# }"
            ((indent_count++))
        done
        
        local clean_line="${line## *}"
        
        # Gestion des listes
        if [[ "$clean_line" =~ ^-[[:space:]]*[\"\']?([^\"\']+)[\"\']?[[:space:]]*$ ]]; then
            local item="${BASH_REMATCH[1]}"
            case "$list_key" in
                "discovery.search_paths")
                    PS_CONFIG_SEARCH_PATHS+=("$item")
                    ;;
                "discovery.exclude_patterns")
                    PS_CONFIG_EXCLUDE_PATTERNS+=("$item")
                    ;;
                "detectors.enabled")
                    PS_CONFIG_ENABLED_DETECTORS+=("$item")
                    ;;
            esac
            continue
        fi
        
        # Gestion des clés-valeurs
        # Simplified pattern matching to avoid regex module dependency
        if [[ "$clean_line" == *":"* ]]; then
            local key="${clean_line%%:*}"
            local value="${clean_line#*:}"
            value="${value## *}"  # Trim leading spaces
            
            # Construire le chemin de section
            case $indent_count in
                0) current_section="$key" ;;
                2) current_section="${current_section%.*}.$key" 2>/dev/null || current_section="$key" ;;
                4) current_section="${current_section%.*.*}.$key" 2>/dev/null || current_section="$key" ;;
            esac
            
            # Détecter début de liste
            if [[ -z "$value" ]]; then
                in_list=true
                list_key="$current_section"
                continue
            else
                in_list=false
                list_key=""
            fi
            
            # Nettoyer la valeur
            value="${value## *}"
            value="${value%% *}"
            value="${value#\"}"
            value="${value%\"}"
            value="${value#\'}"
            value="${value%\'}"
            
            # Stocker la configuration
            [[ -n "$value" && "$value" != "null" ]] && PS_CONFIG[$current_section]="$value"
        fi
    done < "$yaml_file"
}

# ==============================================
# 🏗️ INITIALISATION DE LA CONFIGURATION
# ==============================================
_ps_config_init() {
    local quiet="${1:-true}"
    
    # Créer les répertoires nécessaires dans le projet
    local project_config_dir="configs/project-switcher-config"
    /usr/bin/mkdir -p "$project_config_dir"/{themes,detectors,keybindings}
    
    # Définir chemins relatifs au projet pour éviter les erreurs de sécurité
    PS_CONFIG_DIR="$project_config_dir"
    PS_CONFIG_FILE="$PS_CONFIG_DIR/config.yaml"
    
    # TEMPORARILY DISABLE YAML PARSING (regex issues)
    # Use default configuration only for now
    [[ "$quiet" == "false" ]] && echo "⚙️ Using default configuration (YAML parsing disabled)"
    
    # Initialiser les arrays de configuration si pas chargés depuis YAML
    _ps_config_init_arrays
    
    # Expanding des variables d'environnement
    _ps_config_expand_vars
    
    return 0
}

# ==============================================
# 📋 CRÉATION DE LA CONFIGURATION PAR DÉFAUT
# ==============================================
_ps_config_create_default() {
    cat > "$PS_CONFIG_FILE" << 'EOF'
# ==============================================
# 🏠 MINI SWEET HOME - PROJECT SWITCHER CONFIG  
# ==============================================
# Configuration générée automatiquement
# Personnalisez selon vos besoins !

config_version: "2.0"
user_profile: "default"

# ==============================================
# 🔍 DISCOVERY SETTINGS
# ==============================================
discovery:
  search_paths:
    - "${HOME}/projects"
    - "${HOME}/work"
    - "${HOME}/dev"
    - "${HOME}/code"
    - "${HOME}/src"
    - "${HOME}/repos"
    - "${HOME}/workspace"
    - "${HOME}/business"
    - "${HOME}/Documents/projects"
    - "."
  
  max_depth: 3
  exclude_patterns:
    - "node_modules"
    - ".git"
    - "target" 
    - "dist"
    - "build"
    - "__pycache__"
    - ".venv"
  
  parallel_scan: true
  max_results: 100

# ==============================================
# 🎯 PROJECT DETECTION
# ==============================================
detectors:
  enabled:
    - git
    - nodejs
    - rust
    - go
    - python
    - docker
    - generic

# ==============================================
# 🎨 UI CONFIGURATION
# ==============================================
ui:
  theme: "default"
  show_icons: true
  show_project_types: true
  show_paths: true
  quiet_mode: false
  debug_mode: false
  show_progress: true
  progress_style: "spinner"
  
  colors:
    debug: "magenta"
    info: "cyan"
    success: "green"
    warning: "yellow" 
    error: "red"

# ==============================================
# ⌨️ KEYBINDINGS
# ==============================================
keybindings:
  style: "default"
  fzf:
    select: "enter"
    open_vscode: "ctrl-o"
    open_vim: "ctrl-v"
    refresh: "ctrl-r"
    cancel: "esc"

# ==============================================
# 🖥️ TMUX INTEGRATION
# ==============================================
tmux:
  enabled: true
  auto_create_session: true
  
  session:
    name_template: "${project_name}"
    sanitize_names: true
    
  layout:
    default: "main-horizontal"
    split_horizontal: true
    split_vertical: true
    
  panes:
    auto_split: true
    split_layout: "horizontal"

# ==============================================
# 🔧 INTEGRATIONS
# ==============================================
integrations:
  editors:
    vscode:
      command: "code"
      enabled: true
      
    neovim:
      command: "nvim"
      enabled: true
      
  tools:
    zoxide:
      enabled: true
      auto_add: true
      command: "j"
      
    git:
      show_status: true
      show_branch: true

# ==============================================
# ⚡ PERFORMANCE
# ==============================================
performance:
  cache:
    enabled: true
    ttl: 3600
    
  scanning:
    parallel: true
    max_workers: 4
    timeout: 30
    
  lazy_loading: true
  preload_common: true

# ==============================================
# 📊 ANALYTICS
# ==============================================
analytics:
  enabled: true
  store_usage: true
  
  history:
    max_recent: 50
    max_bookmarks: 20
    auto_bookmark_frequent: true
    frequency_threshold: 5

# ==============================================
# 🐛 LOGGING
# ==============================================
logging:
  level: "info"
  rotate: true
  max_size: "10MB"
  max_files: 5
EOF
}

# ==============================================
# ✅ VALIDATION DE LA CONFIGURATION
# ==============================================
_ps_config_validate() {
    local errors=0
    
    # Vérifier version de config
    local version="${PS_CONFIG[config_version]:-}"
    if [[ -z "$version" ]]; then
        echo "⚠️ Warning: No config version specified, assuming 2.0"
        PS_CONFIG[config_version]="2.0"
    fi
    
    # Vérifier valeurs numériques
    local ttl="${PS_CONFIG[performance.cache.ttl]:-}"
    if [[ -n "$ttl" && ! "$ttl" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: Invalid cache TTL: $ttl"
        ((errors++))
    fi
    
    local max_workers="${PS_CONFIG[performance.scanning.max_workers]:-}"
    if [[ -n "$max_workers" && ! "$max_workers" =~ ^[0-9]+$ ]]; then
        echo "❌ Error: Invalid max_workers: $max_workers"
        ((errors++))
    fi
    
    return $errors
}

# ==============================================
# 🔧 INITIALISATION DES ARRAYS
# ==============================================
_ps_config_init_arrays() {
    # Si les arrays ne sont pas remplis depuis YAML, utiliser les valeurs par défaut
    if (( ${#PS_CONFIG_SEARCH_PATHS[@]} == 0 )); then
        PS_CONFIG_SEARCH_PATHS=(
            "$HOME/projects" 
            "$HOME/work" 
            "$HOME/dev"
            "$HOME/code"
            "$HOME/src"
            "$HOME/repos"
            "$HOME/workspace"
            "$HOME/business"
            "$HOME/Documents/projects"
            "."
        )
    fi
    
    if (( ${#PS_CONFIG_EXCLUDE_PATTERNS[@]} == 0 )); then
        PS_CONFIG_EXCLUDE_PATTERNS=(
            "node_modules" 
            ".git" 
            "target"
            "dist" 
            "build"
            "__pycache__"
            ".venv"
        )
    fi
    
    if (( ${#PS_CONFIG_ENABLED_DETECTORS[@]} == 0 )); then
        PS_CONFIG_ENABLED_DETECTORS=(
            "git"
            "nodejs" 
            "rust"
            "go"
            "python"
            "docker"
            "generic"
        )
    fi
}

# ==============================================
# 🌍 EXPANSION DES VARIABLES D'ENVIRONNEMENT
# ==============================================
_ps_config_expand_vars() {
    local key
    for key in ${(k)PS_CONFIG}; do
        local value="${PS_CONFIG[$key]}"
        # Expansion basique de ${HOME} et variables courantes
        value="${value//\$\{HOME\}/$HOME}"
        value="${value//\$HOME/$HOME}"
        value="${value//\$\{USER\}/$USER}"
        value="${value//\$USER/$USER}"
        PS_CONFIG[$key]="$value"
    done
    
    # Expansion des arrays - simplified for zsh compatibility
    local new_paths=()
    for path in "${PS_CONFIG_SEARCH_PATHS[@]}"; do
        path="${path//\$\{HOME\}/$HOME}"
        path="${path//\$HOME/$HOME}"
        new_paths+=("$path")
    done
    PS_CONFIG_SEARCH_PATHS=("${new_paths[@]}")
}

# ==============================================
# 🎯 GETTERS DE CONFIGURATION
# ==============================================
ps_config_get() {
    local key="$1"
    local default="$2"
    echo "${PS_CONFIG[$key]:-$default}"
}

ps_config_get_bool() {
    local key="$1" 
    local default="${2:-false}"
    local value="${PS_CONFIG[$key]:-$default}"
    
    case "${(L)value}" in
        true|yes|1|on) echo "true" ;;
        *) echo "false" ;;
    esac
}

ps_config_get_int() {
    local key="$1"
    local default="${2:-0}"
    local value="${PS_CONFIG[$key]:-$default}"
    
    [[ "$value" =~ ^[0-9]+$ ]] && echo "$value" || echo "$default"
}

# ==============================================
# 🎨 HELPERS POUR UI
# ==============================================
ps_config_color() {
    local type="$1"  # debug, info, success, warning, error
    local color="${PS_CONFIG[ui.colors.$type]:-white}"
    
    # Conversion nom de couleur vers code ANSI  
    case "${(L)color}" in
        black) echo "0" ;;
        red) echo "1" ;;
        green) echo "2" ;;
        yellow) echo "3" ;;
        blue) echo "4" ;;
        magenta|purple) echo "5" ;;
        cyan) echo "6" ;;
        white) echo "7" ;;
        *) echo "7" ;;  # Default to white
    esac
}

ps_config_show_icons() {
    ps_config_get_bool "ui.show_icons" "true"
}

ps_config_is_quiet() {
    ps_config_get_bool "ui.quiet_mode" "false"
}

ps_config_is_debug() {
    ps_config_get_bool "ui.debug_mode" "false"
}

# ==============================================
# 🎯 DÉTECTEURS CONFIGURABLES
# ==============================================
ps_config_get_detector_info() {
    local detector="$1"
    case "$detector" in
        nodejs)
            echo "📦|Node.js|package.json,yarn.lock,pnpm-lock.yaml|10"
            ;;
        rust)
            echo "🦀|Rust|Cargo.toml,Cargo.lock|10"
            ;;
        go)
            echo "🐹|Go|go.mod,go.sum,main.go|10"
            ;;
        python)
            echo "🐍|Python|pyproject.toml,requirements.txt,setup.py,Pipfile|9"
            ;;
        docker)
            echo "🐳|Docker|Dockerfile,docker-compose.yml,docker-compose.yaml|7"
            ;;
        git)
            echo "📋|Git Repo|.git|5"
            ;;
        generic)
            echo "📁|Project|README.md,Makefile,LICENSE|1"
            ;;
        *)
            echo "📁|Unknown||1"
            ;;
    esac
}

# ==============================================
# 💾 SAUVEGARDE DE CONFIGURATION
# ==============================================
ps_config_save() {
    echo "💾 Configuration save not implemented yet"
    echo "   Edit manually: $PS_CONFIG_FILE"
    return 0
}

# ==============================================
# 🔄 RECHARGEMENT DE CONFIGURATION
# ==============================================
ps_config_reload() {
    echo "🔄 Reloading configuration..."
    _ps_config_init false
    echo "✅ Configuration reloaded successfully"
}

# ==============================================
# ℹ️ INFO DE CONFIGURATION
# ==============================================
ps_config_info() {
    echo "🏗️ PROJECT SWITCHER CONFIGURATION"
    echo ""
    echo "📁 Config file: $PS_CONFIG_FILE"
    echo "📊 Config dir:  $PS_CONFIG_DIR" 
    echo "🔧 Version:     $(ps_config_get 'config_version' 'unknown')"
    echo ""
    echo "🔍 Search paths (${#PS_CONFIG_SEARCH_PATHS[@]}):"
    local i=1
    for path in "${PS_CONFIG_SEARCH_PATHS[@]}"; do
        local path_status="❌"
        [[ -d "$path" ]] && path_status="✅"
        echo "   $i. $path_status $path"
        ((i++))
    done
    echo ""
    echo "🎯 Enabled detectors (${#PS_CONFIG_ENABLED_DETECTORS[@]}):"
    for detector in "${PS_CONFIG_ENABLED_DETECTORS[@]}"; do
        local info=$(ps_config_get_detector_info "$detector")
        local icon="${info%%|*}"
        local label="${info#*|}"
        label="${label%%|*}"
        echo "   $icon $label"
    done
    echo ""
    echo "⚙️ Key settings:"
    echo "   Theme:        $(ps_config_get 'ui.theme' 'default')"
    echo "   Show icons:   $(ps_config_get_bool 'ui.show_icons')"
    echo "   Cache:        $(ps_config_get_bool 'performance.cache.enabled')"
    echo "   TMUX:         $(ps_config_get_bool 'tmux.enabled')"
    echo "   Debug:        $(ps_config_get_bool 'ui.debug_mode')"
    echo "   Quiet:        $(ps_config_get_bool 'ui.quiet_mode')"
}