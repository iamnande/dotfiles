{ pkgs, ... }: {

  home.packages = [ pkgs.fishPlugins.tide ];

  programs.fish = {
    enable = true;

    shellInit = ''
      # ENV
      set -gx EDITOR hx

      # PATH
      test -f "$HOME/.cargo/env.fish"; and source "$HOME/.cargo/env.fish"
      fish_add_path "$HOME/.local/bin"
    '';

    interactiveShellInit = ''
      set -g fish_greeting

      set -l agent_sock ~/.ssh/agent.sock
      # when a live forwarded socket is present, keep the stable symlink current
      if set -q SSH_AUTH_SOCK; and test "$SSH_AUTH_SOCK" != $agent_sock
          ln -sf $SSH_AUTH_SOCK $agent_sock
      end
      set -gx SSH_AUTH_SOCK $agent_sock
    '';

    functions = {
      k   = { wraps = "kubectl";  description = "kubectl";  body = "kubectl $argv"; };
      kns = { wraps = "kubens";   description = "kubens";   body = "kubens $argv"; };
      ktx = { wraps = "kubectx";  description = "kubectx";  body = "kubectx $argv"; };
      mkd = { wraps = "mkdir";    description = "no really, make the dirs"; body = "mkdir -p $argv"; };
      tre = {                     description = "happy little trees"; body = "tree -aC -I .git $argv | less -FRNX"; };
      z   = { wraps = "zellij";   description = "zellij";   body = "zellij $argv"; };
    };
  };

  # tide prompt config — sourced on every shell start
  xdg.configFile."fish/conf.d/tide.fish".source = ./fish/tide.fish;

}
