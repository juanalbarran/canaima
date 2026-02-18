# home/modules/foot/default.nix
{
  programs.foot = {
    enable = true;
    # Foot doesn't have a direct 'config-file' array like Ghostty.
    # We will point Foot to the symlink created by your script.
    settings = {
      main = {
        # This tells foot to load your toggled theme
        include = "~/.cache/style/foot-theme";
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:size=12";
        pad = "10x10center";
        selection-target = "clipboard";
      };

      cursor = {
        style = "block";
        blink = "no";
      };

      mouse = {
        hide-when-typing = "no";
      };

      # Translating your Ghostty Keybinds
      key-bindings = {
        scrollback-up-page = "Shift+Page_Up";
        scrollback-down-page = "Shift+Page_Down";
        clipboard-copy = "Control+Shift+c";
        clipboard-paste = "Control+Shift+v";
        font-increase = "Control+plus Control+equal";
        font-decrease = "Control+minus";
        font-reset = "Control+0";
        spawn-terminal = "Control+Shift+n";
        fullscreen = "Control+Return";
      };
    };
  };
}
