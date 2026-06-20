# yeah, no. thanks though.
set -g fish_greeting

# ludicrous speed! now!!!
if status is-login && test (tty) = /dev/tty1
    exec uwsm start hyprland.desktop
end

# my (current) ride or die
function hx --wraps helix --description helix
    helix $argv
end

# we don't talk about that dark place over there - where YAML goes to die.
function k --wraps kubectl --description k8s
    kubectl $argv
end

function kns --wraps kubens --description "kube namespace"
    kubens $argv
end

function ktx --wraps kubectx --description "kube context"
    kubectx $argv
end

# release the files
function ls --wraps eza --description "list the files"
    eza -lh --group-directories-first --time-style=long-iso --git
end

# ermergerhd... make the damn dirs
function mkd --wraps mkdir --description "no really, make the dirs"
    mkdir -p $argv
end

# go make some trees, some happy little trees
# (if we're using tre, we have done messed up ay-ay-ron)
function tre --description "happy little trees"
    eza --tree --level=2
end

# like, it's just a lot of letters jan. "zellij" is super cute and oui french -
# ain't nobody got time for all that.
function z --wraps zellij --description zellij
    zellij $argv
end

# claim your fighter! (helix atm)
set -gx EDITOR hx

# okay, so like - friends don't let friends distribute their identity across
# machines.. or really, anywhere outside a secure vault.
#
# here we're using 1password agent forwarding to make sure <me> is kept locked
# away in a vault.
set -gx SSH_AUTH_SOCK ~/.1password/agent.sock

# n: i know kung-fu.
# m: show me.
fish_add_path $HOME/.local/bin
if status is-interactive && not set -q ZELLIJ
    z a -c mhq
end
