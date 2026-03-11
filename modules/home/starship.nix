{ pkgs, ... }:
{
  programs.starship.enable = true;

  xdg.configFile."starship.toml".source = pkgs.runCommand "starship-tokyo-night.toml" { } ''
    ${pkgs.starship}/bin/starship preset tokyo-night -o $out
  '';
}
