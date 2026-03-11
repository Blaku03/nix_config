{ lib, primaryUser, ... }:
{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/kitty.nix
    ../../modules/home/ssh.nix
    ../../modules/home/fish.nix
    ../../modules/home/starship.nix
  ];

  home.username = primaryUser;
  home.homeDirectory = lib.mkForce "/Users/${primaryUser}";
  home.stateVersion = "25.11";
}
