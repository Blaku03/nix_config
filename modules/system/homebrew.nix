{ ... }:
{
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
    ];
    masApps = {
      Xcode = 497799835;
    };
    onActivation.cleanup = "zap";
    onActivation.extraFlags = [ "--verbose" ];
  };
}
