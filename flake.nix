{
  description = "nick's dotfiles — home-manager module";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url            = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    # consumed by homelab compute flake
    homeManagerModules.nick = import ./modules/nick.nix;

    # standalone activation (bootstrap or local switch)
    homeConfigurations.nick = home-manager.lib.homeManagerConfiguration {
      pkgs    = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./modules/nick.nix
        {
          home.username      = "nick";
          home.homeDirectory = "/home/nick";
          home.stateVersion  = "24.11";
        }
      ];
    };
  };
}
