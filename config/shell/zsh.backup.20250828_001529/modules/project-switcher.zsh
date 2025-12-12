#!/usr/bin/env zsh

# ===============================
# 🚀 PROJECT SWITCHER v2.0 - Senior Architecture
# ===============================
# Intelligent project discovery and navigation with tmux integration
# Author: MSH Team | Version: 2.0 | Architecture: Senior Level

# ==============================================
# 🏗️ CONFIGURATION SYSTEM DISABLED
# ==============================================
# TEMPORARILY DISABLED due to zsh regex module issues
# Using hardcoded defaults instead
# source "${0:a:h}/project-switcher/core/config.zsh"
# _ps_config_init true

# Global configuration (hardcoded defaults - config system disabled)
MINISWEET_PS_VERSION="2.0"  
MINISWEET_PS_MAX_DEPTH=5
MINISWEET_PS_PREVIEW_LINES=15
MINISWEET_PS_MAX_PROJECTS=50

# State variables (will be set during execution)
# Note: These are initialized inside the function to avoid global scope issues

# ===============================
# 🎯 MAIN ENTRY POINT
# ===============================
project_switch() {
    # Reset state for each invocation (global to be accessible in sub-functions)
    unset debug_mode quiet_mode tmux_mode existing_dirs discovered_projects early_exit
    
    # Initialize with hardcoded defaults (config system disabled)
    debug_mode=false
    quiet_mode=false  
    tmux_mode=true
    tmux_auto_attach=false
    existing_dirs=()
    discovered_projects=""
    early_exit=false
    
    # Parse arguments first (may exit early for --help, --version)
    _ps_parse_args "$@" || return $?
    
    # Exit early if it was just an info request
    [[ $early_exit == true ]] && return 0
    
    # Continue with main flow
    _ps_validate_environment || return $?
    _ps_discover_projects || return $?
    _ps_present_selection || return $?
    _ps_handle_selection || return $?
}

# ===============================
# 🔧 ARGUMENT PARSING
# ===============================
_ps_parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--debug)     debug_mode=true ;;
            -q|--quiet)     quiet_mode=true ;;
            --no-tmux)      tmux_mode=false ;;
            --attach)       tmux_auto_attach=true ;;  # New: force auto-attachment
            -h|--help)      _ps_show_help; early_exit=true; return 0 ;;
            -v|--version)   echo "project_switch v$MINISWEET_PS_VERSION"; early_exit=true; return 0 ;;
            *)              _ps_error "Unknown option: $1"; _ps_show_help; return 1 ;;
        esac
        shift
    done
}

# ===============================
# ✅ ENVIRONMENT VALIDATION
# ===============================
_ps_validate_environment() {
    # Check for fzf directly
    if ! /usr/bin/fzf --version >/dev/null 2>&1; then
        _ps_error "Missing required tool: fzf"
        _ps_error "Install with: sudo apt install fzf  # or your package manager"
        return 1
    fi
    
    [[ $debug_mode == true ]] && _ps_debug "Environment validated ✓ (fzf found)"
    return 0
}

# ===============================
# 🔍 PROJECT DISCOVERY
# ===============================
_ps_discover_projects() {
    # Use hardcoded search paths (config system disabled)
    local -a search_paths=(
        "$HOME/business" "$HOME/projects" "$HOME/learn"
        "$HOME/work" "$HOME/dev" "$HOME/code" 
        "$HOME/src" "$HOME/repos" "$HOME/workspace"
        "$PWD"
    )
    
    # Filter existing directories
    existing_dirs=()
    for path in "${search_paths[@]}"; do
        [[ -d "$path" ]] && existing_dirs+=("$path")
    done
    
    if [[ ${#existing_dirs[@]} -eq 0 ]]; then
        _ps_error "No project directories found in common locations"
        _ps_info "Searched paths: ${search_paths[*]}"
        return 1
    fi
    
    [[ $debug_mode == true ]] && _ps_debug "Found ${#existing_dirs[@]} search paths: ${existing_dirs[*]}"
    return 0
}

# ===============================
# 🎨 PROJECT SELECTION UI
# ===============================
_ps_present_selection() {
    [[ $quiet_mode == false ]] && _ps_info "🔍 Discovering projects..."
    
    # Simple direct approach - check for project markers
    discovered_projects=""
    for dir in "${existing_dirs[@]}"; do
        [[ $debug_mode == true ]] && _ps_debug "Checking directory: $dir"
        if [[ -d "$dir" ]]; then
            local has_markers=false
            if [[ -f "$dir/package.json" ]]; then
                has_markers=true
                [[ $debug_mode == true ]] && _ps_debug "Found package.json in $dir"
            fi
            if [[ -f "$dir/Cargo.toml" ]]; then
                has_markers=true
                [[ $debug_mode == true ]] && _ps_debug "Found Cargo.toml in $dir"
            fi
            if [[ -f "$dir/go.mod" ]]; then
                has_markers=true
                [[ $debug_mode == true ]] && _ps_debug "Found go.mod in $dir"
            fi
            if [[ -d "$dir/.git" ]]; then
                has_markers=true
                [[ $debug_mode == true ]] && _ps_debug "Found .git in $dir"
            fi
            
            if [[ $has_markers == true ]]; then
                local name=$(/usr/bin/basename "$dir")
                local type="📁 Project"
                [[ -f "$dir/package.json" ]] && type="📦 Node.js"
                [[ -f "$dir/Cargo.toml" ]] && type="🦀 Rust"
                [[ -f "$dir/go.mod" ]] && type="🐹 Go"
                discovered_projects+="$dir|$name|$type|$dir"$'\n'
                [[ $debug_mode == true ]] && _ps_debug "Added project: $name ($type)"
            else
                [[ $debug_mode == true ]] && _ps_debug "No project markers in $dir"
            fi
        else
            [[ $debug_mode == true ]] && _ps_debug "Directory $dir does not exist"
        fi
    done
    
    if [[ -z "$discovered_projects" ]]; then
        _ps_error "No projects discovered in search paths"
        [[ $debug_mode == true ]] && _ps_debug "Search paths were: ${existing_dirs[*]}"
        return 1
    fi
    
    [[ $debug_mode == true ]] && _ps_debug "Projects found successfully! Count: $(echo -n "$discovered_projects" | /usr/bin/grep -c '|' || echo 0)"
    [[ $debug_mode == true ]] && _ps_debug "Discovered projects data: $discovered_projects"
    return 0
}

# ===============================
# 🔬 PROJECT SCANNING ENGINE
# ===============================
_ps_scan_projects() {
    [[ $debug_mode == true ]] && _ps_debug "Scanning ${#existing_dirs[@]} directories..."
    
    for dir in "${existing_dirs[@]}"; do
        [[ -d "$dir" ]] && _ps_scan_with_find "$dir"
    done
}

_ps_scan_with_fd() {
    local search_dir="$1"
    
    # Project markers (package.json, Cargo.toml, etc.)
    command fd --type file --max-depth "$MINISWEET_PS_MAX_DEPTH" \
       --exclude 'node_modules' --exclude 'target' --exclude '.git' --exclude 'dist' \
       '(package\.json|Cargo\.toml|go\.mod|pyproject\.toml|requirements\.txt|Pipfile|composer\.json|Makefile|CMakeLists\.txt|pom\.xml|build\.gradle)$' \
       "$search_dir" 2>/dev/null | command xargs -r dirname
    
    # Git repositories
    command fd --type directory --hidden --exact-depth 1 '.git' \
       "$search_dir" 2>/dev/null | command xargs -r dirname
    
    # Common project structures
    command fd --type directory --max-depth 3 \
       --exclude 'node_modules' --exclude 'target' --exclude '.git' --exclude 'dist' \
       '(src|app|lib|packages|components|modules|cmd)$' \
       "$search_dir" 2>/dev/null
}

_ps_scan_with_find() {
    local search_dir="$1"
    
    # Project markers
    find "$search_dir" -maxdepth "$MINISWEET_PS_MAX_DEPTH" -type f \
         \( -name "package.json" -o -name "Cargo.toml" -o -name "go.mod" \
         -o -name "pyproject.toml" -o -name "requirements.txt" -o -name "Pipfile" \
         -o -name "composer.json" -o -name "Makefile" -o -name "CMakeLists.txt" \
         -o -name "pom.xml" -o -name "build.gradle" \) \
         -not -path "*/node_modules/*" -not -path "*/target/*" \
         -exec dirname {} \; 2>/dev/null
    
    # Git repositories
    find "$search_dir" -maxdepth "$MINISWEET_PS_MAX_DEPTH" -type d -name '.git' \
         -not -path "*/node_modules/*" \
         -exec dirname {} \; 2>/dev/null
}

# ===============================
# 🔧 DATA PROCESSING
# ===============================
_ps_filter_unique() {
    /usr/bin/sort | /usr/bin/uniq | /usr/bin/grep -v '/\.' | /usr/bin/head -"$MINISWEET_PS_MAX_PROJECTS"
}

_ps_enhance_display() {
    while IFS= read -r project_path; do
        [[ -z "$project_path" ]] && continue
        local project_name=$(command /usr/bin/basename "$project_path")
        local project_type=$(_ps_detect_project_type "$project_path")
        local relative_path=${project_path/#$HOME/\~}
        echo "$project_path|$project_name|$project_type|$relative_path"
    done
}

_ps_detect_project_type() {
    local path="$1"
    
    [[ -f "$path/package.json" ]] && echo "📦 Node.js" && return
    [[ -f "$path/Cargo.toml" ]] && echo "🦀 Rust" && return
    [[ -f "$path/go.mod" ]] && echo "🐹 Go" && return
    [[ -f "$path/pyproject.toml" || -f "$path/requirements.txt" ]] && echo "🐍 Python" && return
    [[ -f "$path/composer.json" ]] && echo "🐘 PHP" && return
    [[ -f "$path/pom.xml" ]] && echo "☕ Java" && return
    [[ -f "$path/build.gradle" ]] && echo "🤖 Gradle" && return
    [[ -f "$path/Makefile" ]] && echo "🔨 Make" && return
    [[ -d "$path/.git" ]] && echo "📋 Git" && return
    echo "📁 Directory"
}

# ===============================
# 🎛️ SELECTION HANDLING
# ===============================
_ps_handle_selection() {
    local selection
    selection=$(echo "$discovered_projects" | \
        /usr/bin/fzf --height 60% --prompt="🚀 Select Project: " \
            --delimiter="|" --with-nth=2,3 \
            --preview="echo '📁 {1}' && echo '━━━━━━━━━━━━━━━━━━━━━━' && /usr/bin/ls -la {1} 2>/dev/null | /usr/bin/head -10" \
            --preview-window=right:50% \
            --bind="ctrl-r:reload(echo '$discovered_projects')" \
            --bind="ctrl-o:execute(code {1})" \
            --header="Enter=Navigate  Ctrl-O=VSCode  Ctrl-R=Refresh")
    
    if [[ -n "$selection" ]]; then
        local project_path=$(echo "$selection" | /usr/bin/cut -d'|' -f1)
        _ps_navigate_to_project "$project_path"
    else
        _ps_warning "No project selected"
        return 1
    fi
}

# ===============================
# 🧭 PROJECT NAVIGATION
# ===============================
_ps_navigate_to_project() {
    local project_path="$1"
    local project_name=$(/usr/bin/basename "$project_path")
    
    cd "$project_path" || {
        _ps_error "Failed to navigate to: $project_path"
        return 1
    }
    
    _ps_success "📁 Navigated to: $project_path"
    
    # Register with zoxide if available (DISABLED - causes shell corruption)
    # /usr/bin/which zoxide >/dev/null 2>&1 && /usr/bin/zoxide add "$project_path" 2>/dev/null || true
    
    # Launch tmux session if enabled
    if [[ $tmux_mode == true ]] && tmux -V >/dev/null 2>&1; then
        _ps_launch_tmux_session "$project_name" "$project_path"
    else
        [[ $tmux_mode == true ]] && _ps_warning "tmux not available - staying in directory"
    fi
}

# ===============================
# 🖥️ TMUX INTEGRATION
# ===============================
_ps_launch_tmux_session() {
    local session_name="$1"
    local project_path="$2"
    
    # Sanitize session name (tmux requirements)
    session_name=$(echo "$session_name" | sed 's/[^a-zA-Z0-9_-]/_/g')
    
    if tmux has-session -t "$session_name" 2>/dev/null; then
        _ps_info "📺 Found existing session: $session_name"
        if [[ $tmux_auto_attach == true ]]; then
            _ps_info "🔗 Auto-attaching to session..."
            tmux attach-session -t "$session_name"
        else
            _ps_info "💡 Use 'tmux attach -t $session_name' to attach manually"
            _ps_info "💡 Or use 'sp --attach' for auto-attachment"
        fi
    else
        _ps_info "🚀 Creating new development session: $session_name"
        
        # Create session with optimal layout
        tmux new-session -d -s "$session_name" -c "$project_path"
        tmux split-window -h -t "$session_name:0" -c "$project_path"
        tmux split-window -v -t "$session_name:0.1" -c "$project_path"
        
        # Smart commands based on project type
        _ps_configure_tmux_panes "$session_name" "$project_path"
        
        tmux select-pane -t "$session_name:0.0"
        
        if [[ $tmux_auto_attach == true ]]; then
            _ps_success "✅ Session '$session_name' created! Auto-attaching..."
            tmux attach-session -t "$session_name"
        else
            _ps_success "✅ Session '$session_name' created and ready!"
            _ps_info "💡 Use 'tmux attach -t $session_name' to attach manually"
            _ps_info "💡 Or use 'sp --attach' for auto-attachment"
        fi
    fi
}

_ps_configure_tmux_panes() {
    local session_name="$1"
    local project_path="$2"
    
    # Main editor pane (left)
    tmux send-keys -t "$session_name:0.0" 'nvim .' C-m
    
    # Dev server/build pane (top right)  
    if [[ -f "$project_path/package.json" ]]; then
        local start_script=$(jq -r '.scripts.dev // .scripts.start // "echo \"No dev script found\""' "$project_path/package.json" 2>/dev/null)
        if [[ "$start_script" != "null" && "$start_script" != "echo \"No dev script found\"" ]]; then
            tmux send-keys -t "$session_name:0.1" 'npm run dev'
        else
            tmux send-keys -t "$session_name:0.1" 'npm start'
        fi
    elif [[ -f "$project_path/Cargo.toml" ]]; then
        tmux send-keys -t "$session_name:0.1" 'cargo watch -x run'
    elif [[ -f "$project_path/go.mod" ]]; then
        tmux send-keys -t "$session_name:0.1" 'go run .'
    elif [[ -f "$project_path/requirements.txt" ]]; then
        tmux send-keys -t "$session_name:0.1" 'python main.py'
    else
        tmux send-keys -t "$session_name:0.1" "echo '🚀 Ready: $session_name'" C-m
    fi
    
    # Git status pane (bottom right)
    tmux send-keys -t "$session_name:0.2" 'git status' C-m
}

# ===============================
# 👁️ PREVIEW SYSTEM
# ===============================

# ===============================
# 🎨 LOGGING & UI FUNCTIONS (Hardcoded colors)
# ===============================
_ps_info()    { [[ $quiet_mode == false ]] && echo -e "\033[36m[INFO]\033[0m $1" >&2; }
_ps_success() { [[ $quiet_mode == false ]] && echo -e "\033[32m[✓]\033[0m $1" >&2; }
_ps_warning() { [[ $quiet_mode == false ]] && echo -e "\033[33m[⚠]\033[0m $1" >&2; }
_ps_error()   { echo -e "\033[31m[✗]\033[0m $1" >&2; }
_ps_debug()   { [[ $debug_mode == true ]] && echo -e "\033[35m[DEBUG]\033[0m $1" >&2; }

# ===============================
# 📖 HELP SYSTEM
# ===============================
_ps_show_help() {
    /usr/bin/cat << 'EOF'
🚀 PROJECT SWITCHER v2.0 - Senior Architecture

DESCRIPTION:
    Intelligent project discovery and navigation with tmux integration.
    Finds projects by scanning for common markers (package.json, Cargo.toml, etc.)
    and Git repositories across your development directories.

USAGE:
    project_switch [OPTIONS]

OPTIONS:
    -d, --debug      Enable debug mode (verbose output)
    -q, --quiet      Quiet mode (minimal output)
    --no-tmux        Skip tmux session creation
    --attach         Auto-attach to tmux session (prevents shell corruption)
    -h, --help       Show this help message
    -v, --version    Show version information

KEYBINDINGS (in fzf):
    Enter            Navigate to selected project
    Ctrl-O           Open project in VSCode
    Ctrl-R           Refresh project list
    Esc              Cancel selection

SEARCH PATHS:
    ~/projects, ~/work, ~/dev, ~/code, ~/src, ~/repos, ~/workspace,
    ~/business, ~/Documents/projects, ~/Documents/code, 
    ~/Desktop/projects, ~/git, current directory

PROJECT TYPES DETECTED:
    📦 Node.js (package.json)    🦀 Rust (Cargo.toml)
    🐹 Go (go.mod)               🐍 Python (pyproject.toml, requirements.txt)
    🐘 PHP (composer.json)       ☕ Java (pom.xml)
    🤖 Gradle (build.gradle)     🔨 Make (Makefile)
    📋 Git repositories          📁 Regular directories

EXAMPLES:
    project_switch              # Interactive project selection
    project_switch --debug      # Debug mode with verbose output
    project_switch --no-tmux    # Skip tmux session creation
    sp                          # Short alias

ALIASES:
    sp    Short alias for project_switch

EOF
}

# ===============================
# 🔗 ALIASES & SHORTCUTS
# ===============================
# Clean up any existing aliases
unalias sp 2>/dev/null || true
unalias project 2>/dev/null || true

# Create clean aliases
alias sp='project_switch'
alias project='project_switch'

# ===============================
# ⚙️ CONFIGURATION MANAGEMENT COMMANDS
# ===============================
project_switch_config() {
    case "${1:-info}" in
        init|create)
            echo "🏗️ Initializing Project Switcher configuration..."
            _ps_config_init false
            ;;
        info|show)
            ps_config_info
            ;;
        edit)
            local config_file="${PS_CONFIG_FILE:-configs/project-switcher-config/config.yaml}"
            if command -v "${EDITOR:-nvim}" >/dev/null 2>&1; then
                ${EDITOR:-nvim} "$config_file"
            else
                echo "📝 Configuration file: $config_file"
                echo "💡 Set EDITOR environment variable to edit automatically"
            fi
            ;;
        reload)
            ps_config_reload
            ;;
        validate)
            echo "✅ Validating configuration..."
            if _ps_config_validate; then
                echo "🎉 Configuration is valid!"
            else
                echo "❌ Configuration has errors!"
                return 1
            fi
            ;;
        path)
            echo "${PS_CONFIG_FILE:-configs/project-switcher-config/config.yaml}"
            ;;
        reset)
            echo "🔄 Resetting to default configuration..."
            local config_file="${PS_CONFIG_FILE:-configs/project-switcher-config/config.yaml}"
            if [[ -f "$config_file" ]]; then
                cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
                echo "📦 Backup saved: $config_file.backup.$(date +%Y%m%d_%H%M%S)"
            fi
            _ps_config_create_default
            echo "✨ Default configuration restored!"
            ;;
        *)
            echo "🛠️ Project Switcher Configuration Manager"
            echo ""
            echo "USAGE:"
            echo "  project_switch_config <command>"
            echo ""
            echo "COMMANDS:"
            echo "  init        Create default configuration"
            echo "  info        Show current configuration summary" 
            echo "  edit        Edit configuration file"
            echo "  reload      Reload configuration from file"
            echo "  validate    Validate configuration syntax"
            echo "  path        Show configuration file path"
            echo "  reset       Reset to default configuration (with backup)"
            echo ""
            echo "ALIASES:"
            echo "  spc         Short alias for project_switch_config"
            echo ""
            echo "EXAMPLES:"
            echo "  spc init    # Create initial config"
            echo "  spc edit    # Edit in \$EDITOR"
            echo "  spc info    # View current settings"
            ;;
    esac
}

# Configuration management aliases
alias spc='project_switch_config'
alias sp-config='project_switch_config'

# ===============================
# 🏁 MODULE LOADED
# ===============================
# Note: Using simplified loading (config system disabled)
echo "🚀 Project Switcher v$MINISWEET_PS_VERSION loaded (simplified mode)"