{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    wget
    nixfmt
    nh
    fastfetch
  ];
}
