{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    package = pkgs.emptyDirectory;
    font = {
      name = "FiraCode Nerd Font";
      size = 16;
    };
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      background_image = "~/.config/assets/background_img.jpg";
      background_image_layout = "scaled";
      background_tint = "0.95";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      confirm_os_window_close = 0;
    };
    # current-theme.conf is written by kitty's theme kitten: `kitten themes`
    extraConfig = "include current-theme.conf";
  };

  xdg.configFile."assets/background_img.jpg".source = ../../assets/background_img.jpg;
}
