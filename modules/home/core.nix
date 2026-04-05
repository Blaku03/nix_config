{ self, ... }:
{
  flake.modules.home.base =
    { lib, config, ... }:
    let
      cfg = config.my;
    in
    {
      options.my = {
        user.name = lib.mkOption {
          type = lib.types.str;
          description = "Primary user name";
        };
        nixConfigDir = lib.mkOption {
          type = lib.types.str;
          description = "Nix configuration directory";
        };
      };

      # We no longer explicitly import other home modules,
      # as everything using `flake.modules.home.base` gets merged automatically.
      # Wait, actually we don't need imports here if they are all just `flake.modules.home.base`
      # in the other files.

      home.username = cfg.user.name;
      home.homeDirectory = lib.mkForce "/Users/${cfg.user.name}";
      home.stateVersion = "25.11";
    };
}
