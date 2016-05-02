# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files for examples

# decide which type of prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color)
    color_prompt=yes
    ;;
  xterm-256color)
    color_prompt=yes
    ;;
esac

# set the fancy prompt
if [ "$color_prompt" = yes ];
then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


# homebrew bash completion
if [ "$(uname)" == "Darwin" ];
then
  if [[ -f /usr/local/bin/brew ]];
  then
    # bash completion on various things
    if [ -d $(/usr/local/bin/brew --prefix) ];
    then
      source $(/usr/local/bin/brew --prefix)/share/bash-completion/bash_completion
      for file in /usr/local/etc/bash_completion.d/*;
      do
        source "${file}"
      done
    fi
    if [[ -d $(/usr/local/bin/brew --prefix)/Cellar ]];
    then
      for file in /usr/local/etc/bash_completion.d/*;
      do
        source "${file}"
   	  done
  	fi
  fi
fi

if [[ -f $HOME/.bash_profile ]];
then
  source $HOME/.bash_profile
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
