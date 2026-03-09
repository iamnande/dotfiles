## ENV -------------------------
set -gx EDITOR hx

## PATH ------------------------
source "$HOME/.cargo/env.fish"

fish_add_path /usr/local/go/bin
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.local/bin"

## ALIAS -----------------------
# TODO(nick): hook up eza
alias vim nvim

## FUNCS -----------------------
function hx --wraps helix --description helix
    helix $argv
end

function k --wraps kubectl --description kubectl
    kubectl $argv
end

function kns --wraps kubens --description kubens
    kubens $argv
end

function ktx --wraps kubectx --description kubectx
    kubectx $argv
end

function mkd --wraps mkdir --description "no really, make the dirs"
    mkdir -p $argv
end

function tre --description "happy little trees"
    tree -aC -I .git $argv | less -FRNX
end

function z --wraps zellij --description zellij
    zellij $argv
end
