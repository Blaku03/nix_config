{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = "";

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
  };
}
