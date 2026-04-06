{
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        wget
        nixfmt
        nh
        fastfetch
      ];

      nix.package = pkgs.lixPackageSets.stable.lix;
    };
}
