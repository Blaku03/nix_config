{ lib, ... }:
{
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
    default = { };
    description = "Flake modules";
  };

  # Keep old options just in case, but they are no longer strictly needed if we migrate everything.
  # Actually, it's safer to just replace them entirely to enforce the new structure.
}
