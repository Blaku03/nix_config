{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = "";

    functions = {
      back.body = "nohup $argv >/dev/null 2>&1 &";
    };

    shellAbbrs = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
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
