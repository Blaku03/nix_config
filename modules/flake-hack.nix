{ lib, ... }:
{
  options.flake.darwinModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
    description = "nix-darwin modules";
  };
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
    default = { };
    description = "home-manager modules";
  };
}
