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

      # Add fish to /etc/shells so it can be set as the login shell.
      programs.fish.enable = true;

      fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ];
    };
}
