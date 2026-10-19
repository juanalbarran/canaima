# ./modules/workspace/aux-terminal.nix
{
  flake.modules.homeManager.workspace = {
    # Ghostty, the second terminal (ui.apps.auxTerminal, mod+shift+q), set up
    # like foot: same font, block cursor, no window decorations
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        window-padding-x = 8;
        window-padding-y = 4;
        window-padding-balance = false;
        window-decoration = false;
        cursor-style = "block";
        cursor-style-blink = false;
        cursor-click-to-move = true;
        mouse-hide-while-typing = false;
        copy-on-select = true;
        clipboard-read = "ask";
        clipboard-write = "allow";
        clipboard-trim-trailing-spaces = true;
        clipboard-paste-protection = true;
        confirm-close-surface = true;
        shell-integration-features = "cursor,no-sudo,title";
        keybind = [
          # Same as foot
          "ctrl+enter=toggle_fullscreen"
          # Same keys as tmux windows and browser tabs. performable: only
          # when there is another tab, otherwise they reach tmux inside
          "performable:alt+shift+left_bracket=previous_tab"
          "performable:alt+shift+right_bracket=next_tab"
        ];
      };
    };
  };
}
