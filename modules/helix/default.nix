{ ... }: {

  programs.helix = {
    enable = true;
    settings = {
      theme = "everforest_dark";
      editor.file-picker = {
        hidden = false;
        git-ignore = true;
      };
    };
  };

}
