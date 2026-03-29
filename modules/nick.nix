{ pkgs, ... }: {

  programs.git = {
    enable = true;

    # global gitignore — HM writes ~/.config/git/ignore and sets core.excludesfile
    ignores = [
      ".DS_Store"
      ".idea/"
    ];

    signing = {
      key = null; # resolved via ssh-add -L / defaultKeyCommand
      signByDefault = true;
    };

    settings = {
      user = {
        name  = "Nick Anderson";
        email = "nick@morethq.com";
      };

      alias = {
        # get with the times!
        up = "!f() { \
          current_branch=$(git symbolic-ref --short HEAD); \
          default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'); \
          default=\${default:-main}; \
          git checkout $default && \
          git fetch && \
          git pull origin $default && \
          git checkout $current_branch && \
          git rebase $default; \
          }; f";

        # JA: "wtf did you do? 😅"
        lg = "log --pretty=oneline -n 10 --graph --abbrev-commit";

        # dude, where am i?
        stat = "status -s";

        # success, let's have another
        merged = "!f() { \
          current_branch=$(git rev-parse --abbrev-ref HEAD); \
          default=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'); \
          default=\${default:-main}; \
          git checkout $default && \
          git branch -D \"$current_branch\" && \
          git up && \
          git checkout -b \"$1\"; \
          }; f";
      };

      core = {
        editor   = "hx";
        pager    = "less -FRX";
        autocrlf = "input";
      };

      init.defaultBranch = "main";

      gpg.format = "ssh";
      "gpg \"ssh\"".defaultKeyCommand = "ssh-add -L";

      fetch.prune = true;
      push.default = "simple";
      help.autocorrect = 10;
      diff.renames = "copies";
      advice.skippedCherryPicks = false;
    };
  };

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
