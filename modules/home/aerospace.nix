{
  flake.modules.homeManager.aerospace =
    { ... }:
    {
      programs.aerospace = {
        enable = true;
        launchd.enable = true;

        userSettings = {
          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";
          key-mapping.preset = "qwerty";

          gaps = {
            inner.horizontal = 0;
            inner.vertical = 0;
            outer.left = 0;
            outer.right = 0;
            outer.top = 0;
            outer.bottom = 0;
          };

          mode.main.binding = {
            # Focus - strzalki bezpieczne dla polskich znakow
            "alt-left" = "focus left";
            "alt-right" = "focus right";
            "alt-up" = "focus up";
            "alt-down" = "focus down";

            # Przesuniecie okna
            "alt-shift-left" = "move left";
            "alt-shift-right" = "move right";
            "alt-shift-up" = "move up";
            "alt-shift-down" = "move down";

            # Workspacey numeryczne - cyfry bezpieczne dla polskich znakow
            "alt-1" = "workspace 1";
            "alt-2" = "workspace 2";
            "alt-3" = "workspace 3";
            "alt-4" = "workspace 4";
            "alt-5" = "workspace 5";
            "alt-6" = "workspace 6";
            "alt-7" = "workspace 7";
            "alt-8" = "workspace 8";
            "alt-9" = "workspace 9";

            "alt-shift-1" = "move-node-to-workspace 1";
            "alt-shift-2" = "move-node-to-workspace 2";
            "alt-shift-3" = "move-node-to-workspace 3";
            "alt-shift-4" = "move-node-to-workspace 4";
            "alt-shift-5" = "move-node-to-workspace 5";
            "alt-shift-6" = "move-node-to-workspace 6";
            "alt-shift-7" = "move-node-to-workspace 7";
            "alt-shift-8" = "move-node-to-workspace 8";
            "alt-shift-9" = "move-node-to-workspace 9";

            # Nazwane workspacey
            "alt-t" = "workspace terminal";
            "alt-b" = "workspace browser";

            "alt-shift-t" = "move-node-to-workspace terminal";
            "alt-shift-b" = "move-node-to-workspace browser";

            # Uklad
            "alt-slash" = "layout tiles horizontal vertical";
            "alt-comma" = "layout accordion horizontal vertical";

            # Pelny ekran
            "alt-f" = "fullscreen";

            # Przeladowanie konfiguracji
            "alt-shift-r" = "reload-config";

            # Tryb zmiany rozmiaru
            "alt-r" = "mode resize";
          };

          mode.resize.binding = {
            left = "resize width -50";
            right = "resize width +50";
            up = "resize height -50";
            down = "resize height +50";
            enter = "mode main";
            esc = "mode main";
          };
        };
      };
    };
}
