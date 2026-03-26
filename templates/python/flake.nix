{
  description = "Basic python configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              python312
              uv
            ];

            shellHook = ''
              # force uv to use Nix Python
              export UV_PYTHON=${pkgs.python312}/bin/python3

              # never auto-download Python
              export UV_PYTHON_PREFERENCE="only-system"
              export UV_PYTHON_DOWNLOADS="never"

              # prevent Nix packages leaking into venv
              unset PYTHONPATH

              if [ -f uv.lock ]; then
                uv sync --frozen
              else
                uv sync
              fi
              . .venv/bin/activate
            '';
          };
        };
    };
}
