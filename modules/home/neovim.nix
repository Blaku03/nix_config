{
  flake.modules.home.base = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        " Exit insert mode with jk
        inoremap jk <Esc>

        " Use system clipboard
        set clipboard=unnamedplus
      '';
    };
  };
}
