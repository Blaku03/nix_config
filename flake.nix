{
  description = "Mac nix flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      nixConfigDir = "$HOME/.config/nix";
      primaryUser = "bartekbrzyski";

      configuration =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            neovim
            git
            curl
            wget
            nixfmt
          ];

          nix-homebrew = {
            enable = true;
            user = primaryUser;
          };

          homebrew = {
            enable = true;
            casks = [
              "steam"
            ];
            onActivation.cleanup = "zap";
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          # Shell aliases for darwin-rebuild.
          # nrs = nix rebuild switch
          environment.shellAliases = {
            nrs = "sudo darwin-rebuild switch --flake ${nixConfigDir}#$(hostname -s)";
            nrup = "nix flake update ${nixConfigDir}";
            nrb = "sudo darwin-rebuild --rollback";
            nrgc = "sudo nix-collect-garbage --delete-older-than 30d";
          };

          system.primaryUser = primaryUser;
        };

      hostnames = [ "airM4" ];

      mkSystem =
        _:
        nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };

    in
    {
      darwinConfigurations = nixpkgs.lib.genAttrs hostnames mkSystem;

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
    };
}
