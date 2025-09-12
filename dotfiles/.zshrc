
eval "$(/opt/homebrew/bin/brew shellenv)"

alias vi="nvim"

#Init starship
eval "$(starship init zsh)"

# fzf configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bat completions
fpath+=('~/.zsh/completions')

# >>> eza aliases >>>
# Basic setup
alias ls='eza'
alias l='eza -lbF --git'
alias ll='eza -lbGF --git'
alias llm='eza -lbGd --git --sort=modified'
alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'

# Specialty views
alias lS='eza -1'
alias lt='eza --tree --level=2'
alias l.="eza -a | grep -E '^\.'"

# Advanced setup (overrides)
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --icons --octal-permissions --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons'
alias la='eza --long --all --group --group-directories-first'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'
alias lS='eza -1 --color=always --group-directories-first --icons'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"
# <<< eza aliases <<<

# >>> zoxide setup >>>
eval "$(zoxide init zsh)"

# Optional aliases for convenience
alias zz='z'            # quick shortcut to jump
alias zi='zoxide import'  # import directories from autojump or z database
alias cd='z'            # optional: replace cd with z

# >>> zoxide setup <<<
