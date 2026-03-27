{
  flake.darwinModules.myHomebrew = {
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
