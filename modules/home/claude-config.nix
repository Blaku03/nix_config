{ ... }:
{
  flake.modules.homeManager.claudeConfig =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.jq ];

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

      home.file.".claude/CLAUDE.md" = {
        force = true;
        text = ''
          # CLAUDE.md

          Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

          **Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

          ## 1. Think Before Coding

          **Don't assume. Don't hide confusion. Surface tradeoffs.**

          Before implementing:
          - State your assumptions explicitly. If uncertain, ask.
          - If multiple interpretations exist, present them - don't pick silently.
          - If a simpler approach exists, say so. Push back when warranted.
          - If something is unclear, stop. Name what's confusing. Ask.

          ## 2. Simplicity First

          **Minimum code that solves the problem. Nothing speculative.**

          - No features beyond what was asked.
          - No abstractions for single-use code.
          - No "flexibility" or "configurability" that wasn't requested.
          - No error handling for impossible scenarios.
          - If you write 200 lines and it could be 50, rewrite it.

          Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

          ## 3. Surgical Changes

          **Touch only what you must. Clean up only your own mess.**

          When editing existing code:
          - Don't "improve" adjacent code, comments, or formatting.
          - Don't refactor things that aren't broken.
          - Match existing style, even if you'd do it differently.
          - If you notice unrelated dead code, mention it - don't delete it.

          When your changes create orphans:
          - Remove imports/variables/functions that YOUR changes made unused.
          - Don't remove pre-existing dead code unless asked.

          The test: Every changed line should trace directly to the user's request.

          ## 4. Goal-Driven Execution

          **Define success criteria. Loop until verified.**

          Transform tasks into verifiable goals:
          - "Add validation" → "Write tests for invalid inputs, then make them pass"
          - "Fix the bug" → "Write a test that reproduces it, then make it pass"
          - "Refactor X" → "Ensure tests pass before and after"

          For multi-step tasks, state a brief plan:
          ```
          1. [Step] → verify: [check]
          2. [Step] → verify: [check]
          3. [Step] → verify: [check]
          ```

          Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

          ## 5. Destructive Operations

          Even without permission prompts, always confirm with the user before running irreversible shell operations: `rm`, `git reset --hard`, `git push --force`, database drops, overwriting uncommitted changes, etc.

          ## 6. Environment

          - This machine uses **nix-darwin**. Never install tools via `brew install` or suggest it.
          - If a tool is missing, suggest adding it to the nix configuration declaratively.
          - Projects are run inside a nix dev shell. When something is missing (a tool, a package, a dependency), first read `flake.nix` to understand how the project manages its environment, then suggest the appropriate change. For example: if flake uses uv + pyproject.toml for Python, add to `pyproject.toml`; if it manages packages directly in nix, add to `flake.nix`. Never install anything directly (no `pip install`, `cargo install`, `npm install -g`, etc.).

        '';
      };

      home.file.".claude/skills/handoff/SKILL.md" = {
        text = ''
          ---
          name: handoff
          description: Write or update a handoff document so the next agent with fresh context can continue this work.
          ---

          Write or update a handoff document so the next agent with fresh context can continue this work.

          Steps:
          1. Check if HANDOFF.md already exists in the project
          2. If it exists, read it first to understand prior context before updating
          3. Create or update the document with:
             - **Goal**: What we're trying to accomplish
             - **Current Progress**: What's been done so far — summarize older history heavily, focus on immediate context
             - **What Worked**: Approaches that succeeded
             - **What Didn't Work**: Approaches that were wrong or ineffective (so they're not repeated)
             - **Blockers**: Things blocked by external factors (missing API access, waiting on someone, etc.)
             - **Relevant Files**: Exact file paths that were recently edited or are needed for next steps
             - **Next Steps**: Clear action items for continuing

          Keep the document concise. If it already exists, compress older progress into a single summary line — don't let it grow unbounded.

          Save as HANDOFF.md in the project root and tell the user the file path so they can start a fresh conversation with just that path.
        '';
      };

      home.file.".claude/skills/from-handoff/SKILL.md" = {
        text = ''
          ---
          name: from-handoff
          description: Resume work from a HANDOFF.md file at the start of a new session.
          ---

          Resume work from a HANDOFF.md file.

          Steps:
          1. Find HANDOFF.md in the current project root
          2. If not found, tell the user and stop
          3. Read it carefully: goal, progress, what worked, what didn't, blockers, relevant files, next steps
          4. Verify current state: briefly read the key files listed under Relevant Files to confirm they match what HANDOFF.md describes
          5. Tell the user in 2-3 sentences where things stand and what you'll work on next
          6. If the first next step involves irreversible operations (file deletion, git push, database changes, etc.), ask the user to confirm before proceeding
          7. Otherwise proceed with the first next step
        '';
      };

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
