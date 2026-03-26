{
  description = "Mac nix flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
    }:
    let
      nixConfigDir = "$HOME/.config/nix";
      primaryUser = "bartekbrzyski";

      mkSystem =
        hostname:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit self nixConfigDir primaryUser; };
          modules = [
            ./hosts/${hostname}/default.nix
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit nixConfigDir primaryUser; };
              home-manager.backupFileExtension = "bak";
              home-manager.users.${primaryUser} = import ./hosts/${hostname}/home.nix;
            }
          ];
        };

      hostnames = [ "airM4" ];
    in
    {
      templates = {
        default = {
          path = ./templates/default;
          description = "Basic flake-parts template";
        };
        python = {
          path = ./templates/python;
          description = "Python project template";
        };
      };

      darwinConfigurations = nixpkgs.lib.genAttrs hostnames mkSystem;

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
    };
}
