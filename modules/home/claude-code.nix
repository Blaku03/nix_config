{ inputs, ... }:
{
  flake.modules.homeManager.claudeCode =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
      home.packages = [ pkgs.claude-code ];
    };
}
