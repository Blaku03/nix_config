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

          if set -q SSH_CONNECTION; and not set -q ZELLIJ
            zellij attach --create ssh
          end
        '';

        functions = {
          back.body = "nohup $argv >/dev/null 2>&1 &";
          stay.body = ''
            if test -f /tmp/.stay_sleep
                echo "Already active. Run 'unstay' first."
                return 1
            end
            set mins $argv[1]
            if test -z "$mins"
                set mins 2
            end
            if not string match -qr '^-?\d+$' -- $mins
                echo "Usage: stay [N]   N = minutes (>=1), 0 = off now, -1 = never"
                return 1
            end
            set sleep_val (pmset -g | awk '/^ sleep / {print $2}')
            set disp_val (pmset -g | awk '/displaysleep/ {print $2}')
            echo "$sleep_val $disp_val" > /tmp/.stay_sleep

            if test "$mins" = "-1"
                sudo pmset -b sleep 0 disablesleep 1 displaysleep 0
                echo "Awake. Display: never sleeps."
            else if test "$mins" = "0"
                sudo pmset -b sleep 0 disablesleep 1 displaysleep 1
                pmset displaysleepnow
                echo "Awake. Display: off now."
            else
                sudo pmset -b sleep 0 disablesleep 1 displaysleep $mins
                echo "Awake. Display sleeps after $mins min."
            end
            echo "Saved sleep=$sleep_val displaysleep=$disp_val. Run 'unstay' to restore."
          '';
          unstay.body = ''
            if test -f /tmp/.stay_sleep
                read sleep_val disp_val < /tmp/.stay_sleep
                sudo pmset -b sleep $sleep_val disablesleep 0 displaysleep $disp_val
                rm /tmp/.stay_sleep
                echo "Restored sleep=$sleep_val displaysleep=$disp_val"
            else
                echo "No saved state. Forcing defaults (sleep=1 disablesleep=0 displaysleep=2)."
                sudo pmset -b sleep 1 disablesleep 0 displaysleep 2
            end
          '';
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
          csr = "claude --model claude-sonnet-4-6 --dangerously-skip-permissions --resume";
          co = "claude --model claude-opus-4-7 --dangerously-skip-permissions";
          cor = "claude --model claude-opus-4-7 --dangerously-skip-permissions --resume";
          nd = "nix develop";
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

      programs.zellij = {
        enable = true;
        settings = {
          default_shell = "fish";
        };
      };

      home.packages = with pkgs; [ eza ];

      home.sessionVariables = {
        VISUAL = "nvim";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6";
        ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-7";
      };
    };
}
