{
  inputs,
  ...
}:
{

  flake.modules.darwin.base = {
    nix = {
      extraOptions = ''
        # auto-optimise-store = true
        experimental-features = nix-command flakes
      '';
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
        interval = {
          Weekday = 0;
          Hour = 2;
          Minute = 0;
        }; # Weekly at 2 AM
      };
      optimise = {
        automatic = true;
      };
    };
  };
}
