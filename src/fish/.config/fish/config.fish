# shh.. you'll wake the neighbors
if status is-interactive
    if not set -q ZELLIJ; and not set -q SSH_CONNECTION
        exec zellij a -c mhq
    end
end

## ENV -------------------------
set -gx EDITOR nvim

## PATH ------------------------
fish_add_path $HOME/.cargo/bin

## ALIAS -----------------------
alias kns kubens
alias ktx kubectx

# TODO(nick): hook up eza

alias vim nvim

alias z zellij

## FUNCS -----------------------
function hx --wraps helix --description "helix"
    helix $argv
end

function k --wraps kubectl --description "kubectl"
    kubectl $argv
end

function kns --wraps kubens --description "kubens"
    kubens $argv
end

function ktx --wraps kubectx --description "kubectx"
    kubectx $argv
end

function mkd --wraps mkdir --description "no really, make the dirs"
    mkdir -p $argv
end

function tre --description "happy little trees"
    tree -aC -I .git $argv | less -FRNX
end

function v --wraps nvim --description "neovim"
    nvim
end

function z --wraps zellij --description "zellij"
    zellij $argv
end
