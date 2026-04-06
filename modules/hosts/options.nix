{
  lib,
  ...
}:

with lib;
let
  hostOptions = {
    name = mkOption {
      type = types.str;
      example = "nixos";
      description = "Host (machine) name";
    };

    user.name = mkOption {
      type = types.str;
      example = "username";
      default = "bartekbrzyski";
      description = "Host username";
    };

    state = mkOption {
      type = types.submodule {
        options = {
          version = mkOption {
            type = types.str;
            example = "22.05";
            description = "NixOS state version";

          };
          darwin = mkOption {
            type = types.int;
            example = 4;
            description = "Nix-Darwin state version";
          };
        };
      };
    };

    system = mkOption {
      type = types.str;
      example = "x86_64-linux";
      description = "System architecture";
    };

    isNixOS = mkOption {
      type = types.bool;
      default = false;
      description = "If NixOS";
    };

    isDarwin = mkOption {
      type = types.bool;
      default = false;
      description = "If Darwin";
    };

    isHomeManager = mkOption {
      type = types.bool;
      default = false;
      description = "If Home Manager";
    };
  };
in
{
  flake.modules.nixos.base = {
    options.host = hostOptions;
    config.host.isNixOS = lib.mkDefault true;
  };

  flake.modules.darwin.base = {
    options.host = hostOptions;
    config.host.isDarwin = lib.mkDefault true;
  };

  flake.modules.homeManager.base = {
    options.host = hostOptions;
    config.host.isHomeManager = lib.mkDefault true;
  };
}
