{ ... }: {

  home.file = {
    ".claude/CLAUDE.md".source = ./CLAUDE.md;

    ".claude/skills/senzu" = {
      source    = ./skills/senzu;
      recursive = true;
    };

    ".claude/skills/kami" = {
      source    = ./skills/kami;
      recursive = true;
    };

    ".local/bin/senzu" = {
      source     = ./bin/senzu;
      executable = true;
    };

    ".local/bin/senzu-fetch" = {
      source     = ./bin/senzu-fetch;
      executable = true;
    };
  };

}
