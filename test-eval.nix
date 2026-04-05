let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  flakePartsLib = import ./flake.nix; # Wait, flake-parts is not easily importable here
in
null
