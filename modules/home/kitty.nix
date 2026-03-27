{
  flake.homeModules.kitty =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        package = pkgs.emptyDirectory;
        font = {
          name = "FiraCode Nerd Font Mono";
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
          window_padding_width = 30;
        };
        keybindings = {
          "super+1" = "goto_tab 1";
          "super+2" = "goto_tab 2";
          "super+3" = "goto_tab 3";
          "super+4" = "goto_tab 4";
          "super+5" = "goto_tab 5";
        };
        # Keep config self-contained; add theme colors directly here if needed.
        extraConfig = "";
      };

      xdg.configFile."assets/background_img.jpg".source = ../../assets/background_img.jpg;
    };
}
