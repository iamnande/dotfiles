set -g fish_greeting

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
