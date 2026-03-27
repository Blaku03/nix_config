{
  flake.darwinModules.systemBase =
    {
      self,
      pkgs,
      nixConfigDir,
      primaryUser,
      ...
    }:
    let
      userHome = "/Users/${primaryUser}";
      screenshotsDir = "${userHome}/Documents/Screenshots";
    in
    {
      imports = [
        #        ../../modules/system/packages.nix
        #        ../../modules/system/homebrew.nix
        self.darwinModules.myHomebrew
        self.darwinModules.myPackages
      ];

      nix-homebrew = {
        enable = true;
        user = primaryUser;
      };

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
        nrs = "nh darwin switch ${nixConfigDir}#$(hostname -s)";
        nrup = "nix flake update --flake ${nixConfigDir}";
        nrb = "sudo darwin-rebuild --rollback";
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
          AppleShowAllFiles = true;
          FXPreferredViewStyle = "clmv"; # column view
          FXRemoveOldTrashItems = true;
          NewWindowTarget = "Documents";
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
        screencapture.location = screenshotsDir;
      };

      # Create the Screenshots directory and set ownership to the primary user in order to be able so save screenshots.
      system.activationScripts.postActivation.text = ''
        mkdir -p "${screenshotsDir}"
        chown "${primaryUser}" "${screenshotsDir}"
      '';

      security.pam.services.sudo_local.touchIdAuth = true;

      # Add fish to /etc/shells so it can be set as the login shell.
      programs.fish.enable = true;

      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ];
    };
}
