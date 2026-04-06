{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
