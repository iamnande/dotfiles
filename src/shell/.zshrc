# fencing, fighting, torture
# eval "$(zellij setup --generate-auto-start zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"

# we are but poor, lost, circus performers
nerdfetch

# well, it just so happens that your friend here is only mostly dead.
# there's a big difference between mostly dead and all dead.
HISTFILE="${HOME}/.receipts"
HISTSIZE=10000
SAVEHIST=50000
setopt APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# which ways my way?
export EDITOR=nvim
export GOROOT=/usr/local/go
export GOPATH=/usr/local/lib/go
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export PATH_GOROOT="${GOROOT}/bin"
export PATH_GOPATH="${GOPATH}/bin"
export PATH_RANCHER="${HOME}/.rd/bin"
export PATH="${PATH_GOPATH}:${PATH_GOROOT}:${PATH_RANCHER}:${PATH}"

# once word leaks out that a pirate has gone soft, people begin to disobey you.
# then it's nothing but work, work, work - all the time.
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

alias vim="nvim"
alias kns="kubens"
alias ktx="kubectx"
alias ll="ls -lphG"
alias la="ls -laphG"
alias lsd="ls -lphG | grep '^d'"

# yes, you're very smart - shut up.
mkd() {
  mkdir -p "$@"
}

tre() {
  tree -aC -I '.git' "$@" | less -FRNX
}

k() {
  kubectl "$@"
}

v() {
  vim "$@"
}

z() {
  zellij "$@"
}

bop() {
  if bluetoothctl show | grep -q "Powered: no"; then
    bluetoothctl power on >> /dev/null
    sleep 1

    devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
    echo "$devices_paired" | while read -r line; do
      bluetoothctl connect "$line" >> /dev/null
    done
  else
    devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
    echo "$devices_paired" | while read -r line; do
      bluetoothctl disconnect "$line" >> /dev/null
    done
    bluetoothctl power off >> /dev/null
  fi
}

