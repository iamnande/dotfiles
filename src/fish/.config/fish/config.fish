## ENV -------------------------
set -gx EDITOR hx

## PATH ------------------------
test -f "$HOME/.cargo/env.fish"; and source "$HOME/.cargo/env.fish"

fish_add_path "$HOME/.local/bin"

## ALIAS -----------------------
# TODO(nick): hook up eza

## FUNCS -----------------------
if not command -q hx
    function hx --wraps helix --description helix
        helix $argv
    end
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

# remember me
if status is-interactive
    set -l agent_sock ~/.ssh/agent.sock
    # when a live forwarded socket is present, keep the stable symlink current
    if set -q SSH_AUTH_SOCK; and test "$SSH_AUTH_SOCK" != $agent_sock
        ln -sf $SSH_AUTH_SOCK $agent_sock
    end
    set -gx SSH_AUTH_SOCK $agent_sock
end
