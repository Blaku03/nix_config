{ ... }:
{
  flake.modules.homeManager.claudeConfig =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.jq ];

      home.file.".claude/statusline.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          input=$(cat)

          model=$(echo "$input" | jq -r '.model.display_name // "Unknown Model"')
          used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
          current_dir=$(echo "$input" | jq -r '.worktree.original_cwd // empty')
          rl_5h_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' | awk '{printf "%.0f", $1}')
          rl_5h_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

          GREEN='\033[32m'
          YELLOW='\033[33m'
          RED='\033[31m'
          RESET='\033[0m'

          make_bar() {
            pct="$1"
            width=10
            filled=$(( pct * width / 100 ))
            bar=""
            i=0
            while [ $i -lt $filled ]; do bar="''${bar}█"; i=$(( i + 1 )); done
            while [ $i -lt $width ];  do bar="''${bar}░"; i=$(( i + 1 )); done
            printf "%s" "$bar"
          }

          if [ -n "$used" ]; then
            used_int=$(printf "%.0f" "$used")
            bar=$(make_bar "$used_int")
            usage_str="[''${bar}] ''${used_int}%"
          else
            bar=$(make_bar 0)
            usage_str="[''${bar}] 0%"
          fi

          git_str=""
          if git -C "''${current_dir:-.}" rev-parse --git-dir > /dev/null 2>&1; then
            branch=$(git -C "''${current_dir:-.}" branch --show-current 2>/dev/null)
            [ -z "$branch" ] && branch=$(git -C "''${current_dir:-.}" rev-parse --abbrev-ref HEAD 2>/dev/null)
            staged=$(git -C "''${current_dir:-.}" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
            modified=$(git -C "''${current_dir:-.}" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
            git_str="$branch"
            [ "$staged" -gt 0 ] && git_str="''${git_str} $(printf "''${GREEN}+''${staged}''${RESET}")"
            [ "$modified" -gt 0 ] && git_str="''${git_str} $(printf "''${YELLOW}~''${modified}''${RESET}")"
          else
            git_str="no git"
          fi

          format_rl() {
            pct="$1" reset_ts="$2" label="$3"
            [ -z "$pct" ] && return
            if [ "$pct" -ge 90 ]; then color="$RED"
            elif [ "$pct" -ge 70 ]; then color="$YELLOW"
            else color="$GREEN"
            fi
            reset_time=$(date -r "$reset_ts" "+%H:%M" 2>/dev/null || date -d "@$reset_ts" "+%H:%M" 2>/dev/null)
            bar=$(make_bar "$pct")
            printf "''${color}''${label} [''${bar}] ''${pct}%% resets ''${reset_time}''${RESET}"
          }

          rate_limit_str=$(format_rl "$rl_5h_pct" "$rl_5h_reset" "5h")

          repo_root=$(cd "''${current_dir:-.}" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || echo "''${current_dir:-.}")
          dir_display=$(basename "$repo_root")

          printf "  %s | 🧠 %s | ⏱️  %s\n📁 %s | 🌿 %s\n" "$model" "$usage_str" "$rate_limit_str" "$dir_display" "$git_str"
        '';
      };
    };
}
