# ===============================
# 🏠 MINI SWEET HOME ENVIRONMENT
# ===============================

# PATH (with Mini Sweet Home bin)
export PATH="$HOME/mini-sweet-home/bin:$HOME/bin:/usr/local/bin:$HOME/.tmuxifier/bin:$HOME/.local/bin:/usr/local/go/bin:$HOME/go/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Essential environment
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'
export LANG=en_US.UTF-8
export KEYTIMEOUT=1
export BROWSER="/mnt/c/Windows/explorer.exe"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS

# ZSH options
setopt AUTO_CD
setopt CORRECT
setopt NO_CASE_GLOB
setopt GLOB_COMPLETE
setopt AUTO_LIST
setopt AUTO_MENU
setopt ALWAYS_TO_END

# ===============================
# 🎯 VI MODE (STABLE)
# ===============================

# VI mode simple et stable
bindkey -v

# ===============================
# ⌨️ ESSENTIAL KEYBINDINGS
# ===============================

# History search
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^r' history-incremental-search-backward

# Word navigation
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# Edit command in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line
bindkey -M vicmd '^v' edit-command-line

# Quick shortcuts
bindkey -s '^[r' "source ~/.zshrc\n"
bindkey -s '^[g' "clear\n"
bindkey -s '^[e' "nvim ~/.zshrc\n"

# ===============================
# 🧠 COMPLETION SIMPLE
# ===============================

# Load completion
autoload -Uz compinit
compinit -C

# Basic completion styles
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Menu selection bindings
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# ===============================
# 🎨 HIGHLIGHTING SIMPLE
# ===============================

# Syntax highlighting simple
if [[ -f ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestions simple
if [[ -f ~/.zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
fi

# ===============================
# 🗺️ ZOXIDE
# ===============================

# Zoxide
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh --cmd j)"
fi
