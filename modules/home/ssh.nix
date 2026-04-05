{
  flake.modules.home.base = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
    };
  };
}
