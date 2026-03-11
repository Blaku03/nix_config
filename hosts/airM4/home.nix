{ lib, primaryUser, ... }:
{
  imports = [
    ../../modules/home/zsh.nix
    ../../modules/home/git.nix
    ../../modules/home/kitty.nix
    ../../modules/home/ssh.nix
  ];

  home.username = primaryUser;
  home.homeDirectory = lib.mkForce "/Users/${primaryUser}";
  home.stateVersion = "25.11";
}
