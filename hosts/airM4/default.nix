{
  self,
  pkgs,
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
    nrs = "nh darwin switch ${nixConfigDir}#$(hostname -s)";
    nrup = "nix flake update --flake ${nixConfigDir}";
    nrb = "nh darwin rollback";
    nrgc = "sudo nix-collect-garbage --delete-older-than 30d";
  };

  system.primaryUser = primaryUser;

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      show-recents = false;
      minimize-to-application = true;
      orientation = "right";
      tilesize = 48;
      magnification = true;
      largesize = 64;
      persistent-apps = [
        "/Applications/Brave Browser.app"
        "/Applications/kitty.app"
        "/Applications/TickTick.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Discord.app"
      ];
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # column view
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
    };
    screensaver.askForPasswordDelay = 0;
    trackpad.Clicking = true; # tap to click
    controlcenter.BatteryShowPercentage = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Add fish to /etc/shells so it can be set as the login shell.
  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];
}
