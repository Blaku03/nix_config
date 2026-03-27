{ self, ... }:
{
  flake.homeModules.homeBase =
    { lib, primaryUser, ... }:
    {
      imports = [
        self.homeModules.git
        self.homeModules.kitty
        self.homeModules.neovim
        self.homeModules.ssh
        self.homeModules.fish
        self.homeModules.starship
      ];

      home.username = primaryUser;
      home.homeDirectory = lib.mkForce "/Users/${primaryUser}";
      home.stateVersion = "25.11";
    };
}
