{ ... }: {

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "everforest-dark";
      show_startup_tips = false;
      session_name = "mhq";
    };
  };

  xdg.configFile."zellij/themes/everforest-dark.kdl".source = ./themes/everforest-dark.kdl;

}
