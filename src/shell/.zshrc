# fencing, fighting, torture
eval "$(starship init zsh)"

# we are but poor, lost, circus performers
nerdfetch

# which ways my way?
export EDITOR=nvim
export GOROOT=/usr/local/go
export GOPATH=/usr/local/lib/go
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export PATH_GOROOT="${GOROOT}/bin"
export PATH_GOPATH="${GOPATH}/bin"
export PATH="${PATH_GOPATH}:${PATH_GOROOT}:${PATH}"


# once word leaks out that a pirate has gone soft, people begin to disobey you.
# then it's nothing but work, work, work - all the time.
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
