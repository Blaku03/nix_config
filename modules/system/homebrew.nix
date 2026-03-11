{ ... }:
{
  homebrew = {
    enable = true;
    casks = [
      "discord"
      "kitty"
      "signal"
      "steam"
      "visual-studio-code"
      "yaak"
      "brave-browser"
      "ticktick"
    ];
    onActivation.cleanup = "zap";
  };
}
