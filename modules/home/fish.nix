{
  flake.modules.homeManager.fish =
    {
      lib,
      pkgs,
      host,
      ...
    }:
    let
      homeDir =
        if (host.isDarwin or false) then "/Users/${host.user.name}" else "/home/${host.user.name}";
      nixConfigDir = "${homeDir}/.config/nix";

      sharedAliases = {
        nrup = "nix flake update --flake ${nixConfigDir}";
      };

      darwinAliases = {
        nrs = "nh darwin switch ${nixConfigDir}#${host.name}";
        nrb = "sudo darwin-rebuild --rollback";
      };

      nixosAliases = {
        nrs = "nh os switch ${nixConfigDir}#${host.name}";
        nrb = "sudo nixos-rebuild --rollback";
      };
    in
    {
      programs.fish = {
        enable = true;

        shellAliases =
          sharedAliases
          // lib.optionalAttrs (host.isDarwin or false) darwinAliases
          // lib.optionalAttrs (host.isNixOS or false) nixosAliases;

        interactiveShellInit = ''
          set -g fish_color_autosuggestion 555
        '';

        functions = {
          back.body = "nohup $argv >/dev/null 2>&1 &";
          nix.body = ''
            if test "$argv[1]" = "develop"
              command nix develop -c (status fish-path) $argv[2..]
            else
              command nix $argv
            end
          '';
        };

        shellAbbrs = {
          ls = "eza";
          ll = "eza -l";
          la = "eza -la";
          lt = "eza --tree";
          nfi = "nix flake init -t ~/.config/nix#default";
          cs = "claude --model claude-sonnet-4-6 --dangerously-skip-permissions";
          co = "claude --model claude-opus-4-6 --dangerously-skip-permissions";
        };

        plugins = [
          {
            name = "z";
            src = pkgs.fishPlugins.z.src;
          }
          {
            name = "plugin-git";
            src = pkgs.fishPlugins.plugin-git.src;
          }
        ];
      };

      home.packages = with pkgs; [ eza ];

      home.sessionVariables = {
        VISUAL = "nvim";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-6";
      };
    };
}
