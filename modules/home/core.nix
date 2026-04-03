{ self, ... }:
{
  flake.homeModules.core =
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

      imports = [
        self.homeModules.git
        self.homeModules.kitty
        self.homeModules.neovim
        self.homeModules.ssh
        self.homeModules.fish
        self.homeModules.starship
      ];

      home.username = cfg.user.name;
      home.homeDirectory = lib.mkForce "/Users/${cfg.user.name}";
      home.stateVersion = "25.11";
    };
}
