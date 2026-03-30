{ ... }: {

  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "everforest-dark";
      show_startup_tips = false;
    };
  };

  xdg.configFile."zellij/themes/everforest-dark.kdl".source = ./themes/everforest-dark.kdl;

}
