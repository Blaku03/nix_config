{
  inputs,
  ...
}:
{
  flake.modules.darwin.base =
    { config, ... }:
    {
      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

      nix-homebrew = {
        enable = true;
        user = config.host.user.name;
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
