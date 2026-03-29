{ pkgs, lib, ... }: {

  programs.git = {
    enable = true;
    userName = "Nick Anderson";
    userEmail = "nick@morethq.com";

    # global gitignore — HM writes ~/.config/git/ignore and sets core.excludesfile
    ignores = [
      ".DS_Store"
      ".idea/"
    ];

    signing = {
      key = null; # resolved via ssh-add -L / defaultKeyCommand
      signByDefault = true;
    };

    aliases = {
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

    extraConfig = {
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

}
