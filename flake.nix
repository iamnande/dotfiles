{
  description = "nick's dotfiles — home-manager module";

  inputs = { };

  outputs = { self }: {
    homeManagerModules.nick = import ./modules/nick.nix;
  };
}
