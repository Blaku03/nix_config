{
  self,
  nixConfigDir,
  primaryUser,
  ...
}:
{
  imports = [
    ../../modules/system/packages.nix
    ../../modules/system/homebrew.nix
  ];

  nix-homebrew = {
    enable = true;
    user = primaryUser;
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
}
