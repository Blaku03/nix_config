{
  flake.modules.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        wget
        nixfmt
        nixd
        nh
        fastfetch
        awscli2
      ];

      nix.package = pkgs.lixPackageSets.stable.lix;
    };
}
