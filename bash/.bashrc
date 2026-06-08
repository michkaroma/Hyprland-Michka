#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias ga="git add ."
alias gs="git status"
alias gc="git commit -m"
alias gp="git push"
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias search='pacman -Ss'
alias searchyay='yay -Ss'
alias please='sudo'

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

eval "$(zoxide init bash)"

eval "$(starship init bash)"

export EDITOR="code --wait"
