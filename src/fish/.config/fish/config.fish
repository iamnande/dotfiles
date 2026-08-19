# yeah, no. thanks though.
set -g fish_greeting

# ludicrous speed! now!!!
if status is-login && test (tty) = /dev/tty1
    exec uwsm start hyprland.desktop
end

# Arch exposes Helix as `helix`; Homebrew provides the canonical `hx`.
if not type -q hx; and type -q helix
    function hx --wraps helix --description helix
        helix $argv
    end
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

# my alliegance is to the republic... to DEMOCRACY!
# like, it's just a lot of letters jan. "zellij" is super cute and oui french -
# ain't nobody got time for all that.
function z --wraps zellij --description "workspace management"
    zellij $argv
end
if test -d "$HOME/way"
    alias mhq='z -d -l mhq a -c mhq'
else
    alias mhq='z -d a -c mhq'
end
alias tardis='z -d -l tardis a -c tardis'

# claim your fighter! (helix atm)
set -gx EDITOR hx

# okay, so like - friends don't let friends distribute their identity across
# machines.. or really, anywhere outside a secure vault.
#
# here we're using 1password agent forwarding to make sure <me> is kept locked
# away in a vault.
set -l onepassword_agent ~/.1password/agent.sock
if set -q SSH_CONNECTION; and test -S "$SSH_AUTH_SOCK"; and test "$SSH_AUTH_SOCK" != "$onepassword_agent"
    mkdir -p ~/.1password
    ln -sfn "$SSH_AUTH_SOCK" "$onepassword_agent"
end
set -gx SSH_AUTH_SOCK "$onepassword_agent"

# n: i know kung-fu.
# m: show me.
fish_add_path /home/linuxbrew/.linuxbrew/bin
fish_add_path $HOME/.local/bin
if status is-interactive && not set -q ZELLIJ
    mhq
end
