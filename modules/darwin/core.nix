{
  flake.darwinModules.core =
    {
      self,
      lib,
      config,
      ...
    }:
    let
      cfg = config.my;
    in
    {
      options.my = {
        user.name = lib.mkOption {
          type = lib.types.str;
          description = "Primary user name";
        };
        nixConfigDir = lib.mkOption {
          type = lib.types.str;
          description = "Nix configuration directory";
        };
      };

      config = {
        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        nix.gc = {
          automatic = true;
          options = "--delete-older-than 30d";
          interval = {
            Weekday = 0;
            Hour = 2;
            Minute = 0;
          }; # Weekly at 2 AM
        };

        # Deduplicates store paths via hard-linking
        nix.optimise.automatic = true;

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
          nrs = "nh darwin switch ${cfg.nixConfigDir}#$(hostname -s)";
          nrup = "nix flake update --flake ${cfg.nixConfigDir}";
          nrb = "sudo darwin-rebuild --rollback";
        };
      };
    };
}
