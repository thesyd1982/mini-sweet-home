#!/bin/bash
# MSH v3.0 - Modern Tools Fallbacks System
# Intelligent fallbacks for modern CLI tools

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Fuzzy finder fallbacks: fzy → fzf → native find
setup_fuzzy_finder_fallbacks() {
    if command_exists fzy; then
        # fzy is the preferred ultra-fast option
        alias f='fzy'
        alias ff='find . -type f | fzy'
        alias fp='find . -type f | fzy | xargs -r'
        export MSH_FUZZY_FINDER="fzy"
    elif command_exists fzf; then
        # fzf is the fallback
        alias f='fzf'
        alias ff='find . -type f | fzf'
        alias fp='find . -type f | fzf | xargs -r'
        export MSH_FUZZY_FINDER="fzf"
    else
        # Native fallbacks
        alias f='find . -type f | head -20'
        alias ff='find . -type f'
        alias fp='find . -type f | head -10 | xargs -r'
        export MSH_FUZZY_FINDER="find"
    fi
}

# List/tree fallbacks: eza → tree → ls (NO ICONS)
setup_list_fallbacks() {
    if command_exists eza; then
        # eza without icons - clean and fast
        alias ls='eza --group-directories-first'
        alias la='eza --group-directories-first -la'
        alias ll='eza --group-directories-first -l'
        alias tree='eza --tree'
        alias t='eza --tree --level=2'
        alias lt='eza --tree --level=3'
        export MSH_LIST_TOOL="eza"
    elif command_exists tree; then
        # Keep ls as is, use tree for tree view
        alias t='tree -L 2'
        alias lt='tree -L 3'
        export MSH_LIST_TOOL="tree+ls"
    else
        # Pure native fallbacks
        alias la='ls -la'
        alias ll='ls -l'
        alias t='ls -la'
        alias tree='find . -type d | head -20'
        alias lt='find . -type d | head -30'
        export MSH_LIST_TOOL="ls"
    fi
}

# Grep fallbacks: rg → grep
setup_grep_fallbacks() {
    if command_exists rg; then
        # ripgrep is the modern grep
        alias grep='rg'
        alias gg='rg --line-number --color=always'
        alias ggi='rg --ignore-case --line-number --color=always'
        alias ggf='rg --files-with-matches'
        export MSH_GREP_TOOL="rg"
    else
        # Native grep with colors
        alias gg='grep -rn --color=always'
        alias ggi='grep -rin --color=always'
        alias ggf='grep -rl'
        export MSH_GREP_TOOL="grep"
    fi
}

# Find fallbacks: fd → find
setup_find_fallbacks() {
    if command_exists fd; then
        # fd is the modern find
        alias find='fd'
        alias findname='fd --type f'
        alias finddir='fd --type d'
        export MSH_FIND_TOOL="fd"
    else
        # Native find
        alias findname='find . -type f -name'
        alias finddir='find . -type d -name'
        export MSH_FIND_TOOL="find"
    fi
}

# Cat fallbacks: bat → cat
setup_cat_fallbacks() {
    if command_exists bat; then
        # bat is the modern cat with syntax highlighting
        alias cat='bat --paging=never'
        alias bcat='bat'  # explicit bat
        alias less='bat'
        export MSH_CAT_TOOL="bat"
    else
        # Native cat
        alias bcat='cat'
        export MSH_CAT_TOOL="cat"
    fi
}

# Disk usage fallbacks: dust → du
setup_disk_fallbacks() {
    if command_exists dust; then
        # dust is the modern du
        alias du='dust'
        alias duh='dust -r'  # reverse sort (biggest first)
        alias dus='dust -s'  # sort by size
        export MSH_DU_TOOL="dust"
    else
        # Native du
        alias duh='du -h | sort -hr'
        alias dus='du -sh * | sort -h'
        export MSH_DU_TOOL="du"
    fi
}

# Navigation fallbacks: zoxide → cd
setup_navigation_fallbacks() {
    if command_exists zoxide; then
        # zoxide is the smart cd
        eval "$(zoxide init zsh)" 2>/dev/null || eval "$(zoxide init bash)" 2>/dev/null
        alias cd='z'
        alias cdi='zi'  # interactive zoxide
        alias cdb='z -'  # go back
        export MSH_NAV_TOOL="zoxide"
    else
        # Native cd with some enhancements
        alias cdb='cd -'
        alias ..='cd ..'
        alias ...='cd ../..'
        alias ....='cd ../../..'
        export MSH_NAV_TOOL="cd"
    fi
}

# Editor fallbacks: nvim → vim → nano
setup_editor_fallbacks() {
    if command_exists nvim; then
        export EDITOR="nvim"
        alias vi='nvim'
        alias vim='nvim'
        export MSH_EDITOR="nvim"
    elif command_exists vim; then
        export EDITOR="vim"
        alias vi='vim'
        export MSH_EDITOR="vim"
    elif command_exists nano; then
        export EDITOR="nano"
        alias vi='nano'
        alias vim='nano'
        export MSH_EDITOR="nano"
    else
        export EDITOR="vi"
        export MSH_EDITOR="vi"
    fi
}

# Git enhancements (preserve existing functionality)
setup_git_fallbacks() {
    # These work with any git installation
    if command_exists git; then
        # Basic git shortcuts (non-conflicting with existing functions)
        alias gs='git status'
        alias gl='git log --oneline'
        alias gd='git diff'
        alias gb='git branch'
        alias gco='git checkout'
        alias gp='git push'
        alias gpu='git pull'
        export MSH_GIT_TOOL="git"
    fi
}

# Process viewer fallbacks: htop → top
setup_process_fallbacks() {
    if command_exists htop; then
        alias top='htop'
        alias processes='htop'
        export MSH_PROCESS_TOOL="htop"
    elif command_exists btop; then
        alias top='btop'
        alias processes='btop'
        export MSH_PROCESS_TOOL="btop"
    else
        alias processes='top'
        export MSH_PROCESS_TOOL="top"
    fi
}

# Network tools fallbacks
setup_network_fallbacks() {
    # HTTP clients
    if command_exists httpie; then
        alias curl='http'
        export MSH_HTTP_TOOL="httpie"
    elif command_exists curl; then
        export MSH_HTTP_TOOL="curl"
    else
        export MSH_HTTP_TOOL="wget"
    fi
}

# Create intelligent aliases that combine tools
setup_intelligent_aliases() {
    # File search and preview
    if [[ "$MSH_FUZZY_FINDER" == "fzy" ]] && [[ "$MSH_CAT_TOOL" == "bat" ]]; then
        alias preview='fzy | xargs -r bat'
    elif [[ "$MSH_FUZZY_FINDER" == "fzf" ]] && [[ "$MSH_CAT_TOOL" == "bat" ]]; then
        alias preview='fzf --preview "bat --color=always {}"'
    else
        alias preview='find . -type f | head -10 | xargs -r cat'
    fi

    # Smart search: combine find and grep
    if [[ "$MSH_FIND_TOOL" == "fd" ]] && [[ "$MSH_GREP_TOOL" == "rg" ]]; then
        alias search='fd --type f | xargs rg'
        alias searchdir='fd --type d | rg'
    else
        alias search='find . -type f | xargs grep -l'
        alias searchdir='find . -type d | grep'
    fi

    # Quick navigation and listing
    alias lf='$MSH_LIST_TOOL && $MSH_NAV_TOOL'
    
    # Development shortcuts
    if [[ "$MSH_FIND_TOOL" == "fd" ]]; then
        alias findcode='fd "\.(js|ts|py|go|rs|c|cpp|h|hpp)$"'
        alias findconfig='fd "\.(json|yaml|yml|toml|ini|conf)$"'
    else
        alias findcode='find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \)'
        alias findconfig='find . -type f \( -name "*.json" -o -name "*.yaml" -o -name "*.yml" -o -name "*.toml" \)'
    fi
}

# Report what fallbacks were used
report_fallbacks() {
    echo "🛠️ MSH Fallbacks Active:"
    echo "  Fuzzy Finder: $MSH_FUZZY_FINDER"
    echo "  List Tool: $MSH_LIST_TOOL"
    echo "  Grep Tool: $MSH_GREP_TOOL"
    echo "  Find Tool: $MSH_FIND_TOOL"
    echo "  Cat Tool: $MSH_CAT_TOOL"
    echo "  Navigation: $MSH_NAV_TOOL"
    echo "  Editor: $MSH_EDITOR"
    echo "  Git: $MSH_GIT_TOOL"
    echo "  Process Viewer: $MSH_PROCESS_TOOL"
    echo "  HTTP Tool: $MSH_HTTP_TOOL"
}

# Main function to setup all fallbacks
setup_all_fallbacks() {
    local quiet="${1:-false}"
    
    setup_fuzzy_finder_fallbacks
    setup_list_fallbacks
    setup_grep_fallbacks
    setup_find_fallbacks
    setup_cat_fallbacks
    setup_disk_fallbacks
    setup_navigation_fallbacks
    setup_editor_fallbacks
    setup_git_fallbacks
    setup_process_fallbacks
    setup_network_fallbacks
    setup_intelligent_aliases
    
    if [[ "$quiet" != "true" ]]; then
        report_fallbacks
    fi
}

# Export all environment variables for other scripts
export_fallback_vars() {
    export MSH_FALLBACKS_LOADED="true"
    export MSH_FALLBACKS_VERSION="3.0"
    # All MSH_*_TOOL variables are already exported in their respective functions
}

# Main execution
main() {
    case "${1:-setup}" in
        setup)
            setup_all_fallbacks
            export_fallback_vars
            ;;
        quiet)
            setup_all_fallbacks true
            export_fallback_vars
            ;;
        report)
            if [[ "$MSH_FALLBACKS_LOADED" == "true" ]]; then
                report_fallbacks
            else
                echo "❌ Fallbacks not loaded. Run '$0 setup' first."
                exit 1
            fi
            ;;
        test)
            setup_all_fallbacks true
            echo "🧪 Testing fallbacks..."
            echo "  f: $(type f 2>/dev/null | head -1)"
            echo "  ls: $(type ls 2>/dev/null | head -1)"
            echo "  cat: $(type cat 2>/dev/null | head -1)"
            echo "  grep: $(type grep 2>/dev/null | head -1)"
            echo "  find: $(type find 2>/dev/null | head -1)"
            ;;
        help|--help|-h)
            echo "MSH Modern Tools Fallbacks v3.0"
            echo "Usage: $0 [setup|quiet|report|test|help]"
            echo "  setup  - Setup all fallbacks with report (default)"
            echo "  quiet  - Setup all fallbacks silently"
            echo "  report - Show active fallbacks"
            echo "  test   - Test fallback aliases"
            echo "  help   - Show this help"
            ;;
        *)
            echo "Unknown command: $1"
            exit 1
            ;;
    esac
}

# Auto-run if sourced (common case)
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    # Being sourced, run quietly
    setup_all_fallbacks true
    export_fallback_vars
else
    # Being executed directly
    main "$@"
fi