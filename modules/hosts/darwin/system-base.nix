{
  flake.modules.darwin.base =
    {
      config,
      pkgs,
      ...
    }:
    let
      primaryUser = config.host.user.name;
      screenshotsDir = "/Users/${primaryUser}/Documents/Screenshots";
    in
    {
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

      programs.fish.enable = true;

      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ];
    };
}
