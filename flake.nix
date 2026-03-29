{
  description = "nick's dotfiles — home-manager module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, ... }: {
    homeManagerModules.nick = import ./modules/nick.nix;
  };
}
