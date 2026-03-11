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
    ];
    onActivation.cleanup = "zap";
  };
}
