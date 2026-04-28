{ ... }:
{
  flake.modules.homeManager.claudeConfig =
    { ... }:
    {
      home.file.".claude/settings.json" = {
        force = true;
        text = builtins.toJSON {
          model = "claude-sonnet-4-6";
          effortLevel = "medium";
          skipDangerousModePermissionPrompt = true;
          cleanupConfirmation = false;
          permissions = {
            allow = [
              "Bash(cat *)"
              "Bash(ls *)"
              "Bash(echo *)"
              "Bash(curl *)"
              "Bash(grep *)"
              "Bash(rg *)"
              "Bash(find *)"
              "Bash(head *)"
              "Bash(tail *)"
              "Bash(wc *)"
              "Bash(which *)"
              "Bash(pwd)"
              "Bash(env)"
              "Bash(git status)"
              "Bash(git log *)"
              "Bash(git diff *)"
              "Bash(git branch *)"
            ];
          };
          remoteControlAtStartup = true;
          extraKnownMarketplaces = {
            "anthropic-agent-skills" = {
              source = {
                source = "github";
                repo = "anthropics/skills";
              };
            };
          };
          enabledPlugins = {
            "example-skills@anthropic-agent-skills" = true;
          };
          statusLine = {
            type = "command";
            command = "~/.claude/statusline.sh";
            padding = 1;
          };
        };
      };
    };
}
