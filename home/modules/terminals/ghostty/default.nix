# home/modules/ghostty/default.nix
{pkgs, ...}: {
  home.file = {
    #".config/ghostty/config".source = ./config;
    ".config/ghostty/keybinds.conf".source = ./keybinds.conf;
    ".config/ghostty/shaders/cursor-smear.glsl".source = ./cursor-smear.glsl;
    ".config/ghostty/window-rules/nmtui.toml".source = ./window-rules/nmtui.toml;
    ".config/ghostty/window-rules/keybinds.toml".source = ./window-rules/keybinds.toml;
    ".config/ghostty/window-rules/pulsemixer.toml".source = ./window-rules/pulsemixer.toml;
  };
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;

    # Enable Shell Integration
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      # --- THEME INTEGRATION ---
      # This is the magic line. It loads the file symlinked by toggle-theme.sh
      # We use '?' so it doesn't crash if the file is missing initially.
      config-file = [
        "?~/.cache/style/ghostty-theme"
        "keybinds.conf"
      ];

      # --- Fonts ---
      font-family = "JetBrainsMono Nerd Font";
      font-style = "default";
      font-feature = "";
      font-size = 12;

      # --- Window & Appearance ---
      background-opacity = 1;
      window-padding-x = 8;
      window-padding-y = 4;
      window-padding-balance = false;
      window-decoration = false;

      # --- Cursor ---
      cursor-style = "block";
      cursor-style-blink = false;
      cursor-click-to-move = true;

      # --- Clipboard ---
      clipboard-read = "ask";
      clipboard-write = "allow";
      clipboard-trim-trailing-spaces = true;
      clipboard-paste-protection = true;
      copy-on-select = true;

      # --- GTK / Linux Specifics ---
      gtk-titlebar = true;
      gtk-tabs-location = "top";
      gtk-wide-tabs = true;
      # gtk-adwaita = true; # Enabled by default usually

      # --- Misc ---
      mouse-hide-while-typing = false;
      confirm-close-surface = true;
      shell-integration = "detect";
      shell-integration-features = "cursor,no-sudo,title";

      # We removed the hardcoded 'background'/'foreground' lines
      # because the theme file will provide them!
    };
  };
}
