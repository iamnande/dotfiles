set -g fish_greeting

# the path is fixed. 1password does not move it. auth and signing both depend on it.
# change agents, change this line.
set -gx SSH_AUTH_SOCK ~/.1password/agent.sock

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
