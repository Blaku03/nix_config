{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Blaku03";
        email = "the.bainow03@gmail.com";
      };
      settings.push.autoSetupRemote = true;
      ignores = [
        ".DS_Store"
        "**/.claude/settings.local.json"
      ];
    };
  };
}
