{ ... }: {

  home.file = {
    ".claude/CLAUDE.md".source             = ./CLAUDE.md;
    ".claude/skills/senzu/SKILL.md".source = ./skills/senzu/SKILL.md;

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
