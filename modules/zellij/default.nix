{ ... }: {

  programs.zellij = {
    enable = true;
    settings = {
      theme = "everforest-dark";
      show_startup_tips = false;
      session_name = "mhq";
    };
  };

  programs.fish.interactiveShellInit = ''
    if not set -q ZELLIJ
        zellij attach -c mhq
    end
  '';

  xdg.configFile."zellij/themes/everforest-dark.kdl".source = ./themes/everforest-dark.kdl;

}
