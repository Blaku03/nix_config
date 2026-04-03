{
  flake.darwinModules.homebrew =
    { config, ... }:
    {
      nix-homebrew = {
        enable = true;
        user = config.my.user.name;
      };

      homebrew = {
        enable = true;
        casks = [
          "discord"
          "kitty"
          "rectangle"
          "signal"
          "steam"
          "visual-studio-code"
          "yaak"
          "brave-browser"
          "ticktick"
          "antigravity"
          "firefox"
        ];
        masApps = {
          Xcode = 497799835;
        };
        onActivation.cleanup = "zap";
        onActivation.extraFlags = [ "--verbose" ];
      };
    };
}
