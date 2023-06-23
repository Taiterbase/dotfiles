# Add binaries folder 
PATH="$HOME/box/binaries/:$PATH"

function kubectl_bash() {
    kubectl exec -it $1 -- /bin/bash
}

alias kbash=kubectl_bash
alias k='kubectl'
alias gs='git status'
alias gp='git push'
alias gc='git commit -m'
alias gd='git diff'
alias ga='git add'
alias gr='git reset'
