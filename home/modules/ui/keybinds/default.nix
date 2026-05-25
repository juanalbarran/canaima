# home/modules/ui/keybinds/default.nix
{config, ...}: let
  vars = rec {
    swayMod = "Mod4";
    hyprMod = "SUPER";
    path =
      if config.hostSpec.isNixOS
      then ""
      else "$HOME/.nix-profile/bin/";

    # Run-or-raise apps
    runOrRaiseApps = {
      terminal = {
        keybind = "$mod+q";
        app = config.hostSpec.terminal;
        appId = config.hostSpec.terminalAppId;
      };
      auxTerminal = {
        keybind = "$mod+Shift+q";
        app = config.hostSpec.auxTerminal;
        appId = config.hostSpec.auxTerminalAppId;
      };
      ai = {
        keybind = "$mod+a";
        app = config.hostSpec.ai;
        appId = config.hostSpec.aiAppId;
        extraCriteria = ''title="Gemini"'';
      };
      browser = {
        keybind = "$mod+b";
        app = config.hostSpec.browser;
        appId = config.hostSpec.browserAppId;
      };
      slack = {
        keybind = "$mod+s";
        app = "slack";
        appId = "Slack";
      };
      firefox = {
        keybind = "$mod+f";
        app = "firefox";
        appId = "firefox";
      };
      chrome = {
        keybind = "$mod+g";
        app = "google-chrome-stable";
        appId = "google-chrome";
      };
      factorio = {
        keybind = "$mod+Shift+f";
        app = "~/games/factorio/bin/x64/factorio";
        appId = "Factorio";
        matchBy = "title";
      };
    };

    # Actions
    actions = {
      kill = {
        keybind = "$mod+c";
        sway = "kill";
        hypr = "killactive,";
      };
      launcher = {
        keybind = "$mod+d";
        cmd = "system-menu";
      };
      bookmarks = {
        keybind = "$mod+m";
        cmd = "bookmarks";
      };
      projects = {
        keybind = "$mod+p";
        cmd = "projects";
      };
      projectsCtwo = {
        keybind = "$mod+Shift+p";
        cmd = "projects-ctwo";
      };
      wallpaper = {
        keybind = "$mod+Shift+w";
        sway = "exec ${path}wallpaper";
        hypr = "exec, wallpaper-manager";
      };
      lock = {
        keybind = "$mod+Ctrl+q";
        sway = "exec swaylock --image $(cat ~/.cache/style/current_wallpaper)";
        hypr = "exec, $lock";
      };
      theme = {
        keybind = "$mod+Shift+Ctrl+t";
        cmd = "toggle-theme";
      };
      keybinds = {
        keybind = "$mod+Shift+slash";
        cmd = "foot -a keybinds keybinds";
      };
      network = {
        keybind = "$mod+Shift+i";
        cmd = "foot -a network sh -c ~/.nix-profile/bin/gazelle";
      };
      reload = {
        keybind = "$mod+Shift+c";
        sway = "reload";
        hypr = "exec, hyprctl reload";
      };
      exit = {
        keybind = "$mod+Shift+e";
        sway = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
        hypr = "exit,";
      };
    };
  };
in {
  imports = [
    (import ./sway.nix vars)
    (import ./hyprland.nix vars)
  ];
}
