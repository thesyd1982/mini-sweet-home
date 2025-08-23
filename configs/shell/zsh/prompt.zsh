# ===============================
# ⚡ DOTFILES V4 - PROMPT
# ===============================

setopt PROMPT_SUBST

# Git info (cached for speed)
git_prompt_info() {
    local ref
    ref=$(git symbolic-ref HEAD 2>/dev/null) || return
    local branch="${ref#refs/heads/}"
    local status_color="%F{green}"
    [[ -n $(git status --porcelain 2>/dev/null) ]] && status_color="%F{red}"
    echo " ${status_color}${branch}%f"
}

# Prompt original avec lambda et chevron blanc
PROMPT='%(?.%F{green}.%F{red})λ%f %B%F{white}›%f%b '
RPROMPT='%F{255}%~%f$(git_prompt_info)'
