# TODO: broooo.. we gotta organize here.
# this is mass bloody chaos. (organic growth is good)

# yeah, no. thanks though.
set -g fish_greeting

# ludicrous speed! now!!!
if status is-login && test (tty) = /dev/tty1
    exec uwsm start hyprland.desktop
end

# y'all need unions, and it shows
if not type -q hx; and type -q helix
    function hx --wraps helix --description helix
        helix $argv
    end
end

# claim your fighter! (helix atm)
set -gx EDITOR hx

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
    eza -lh --group-directories-first --time-style=long-iso --git $argv
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

# my alliegance is to the republic... to DEMOCRACY!
# like, it's just a lot of letters jan. "zellij" is super cute and oui french -
# ain't nobody got time for all that.
function z --wraps zellij --description "workspace management"
    zellij $argv
end

# n: i know kung-fu.
# m: show me.
fish_add_path /home/linuxbrew/.linuxbrew/bin
fish_add_path $HOME/.local/bin

# where we going?
set -q LANDING_SESSION; or set -g LANDING_SESSION mhq
if status is-interactive && not set -q ZELLIJ
    z delete-session $LANDING_SESSION >/dev/null 2>&1
    z -d -l $LANDING_SESSION a -c $LANDING_SESSION
end
