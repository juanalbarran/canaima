# home/modules/ui/keybinds/default.nix
{
  config,
  lib,
  ...
}: let
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
        name = "Terminal";
        app = config.hostSpec.terminal;
        appId = config.hostSpec.terminalAppId;
      };
      auxTerminal = {
        keybind = "$mod+Shift+q";
        name = "Aux Terminal";
        app = config.hostSpec.auxTerminal;
        appId = config.hostSpec.auxTerminalAppId;
      };
      ai = {
        keybind = "$mod+a";
        name = "AI / Gemini";
        app = config.hostSpec.ai;
        appId = config.hostSpec.aiAppId;
        extraCriteria = ''title="Gemini"'';
      };
      browser = {
        keybind = "$mod+b";
        name = "Browser";
        app = config.hostSpec.browser;
        appId = config.hostSpec.browserAppId;
      };
      slack = {
        keybind = "$mod+s";
        name = "Slack";
        app = "slack";
        appId = "Slack";
      };
      firefox = {
        keybind = "$mod+f";
        name = "Firefox";
        app = "firefox";
        appId = "firefox";
      };
      chrome = {
        keybind = "$mod+g";
        name = "Chrome";
        app = "google-chrome-stable";
        appId = "google-chrome";
      };
      factorio = {
        keybind = "$mod+Shift+f";
        name = "Factorio";
        app = "~/games/factorio/bin/x64/factorio";
        appId = "Factorio";
        matchBy = "title";
      };
    };

    # Screenshots
    screenshots = {
      full = {
        keybind = "Print";
        name = "Full screen → file";
      };
      area = {
        keybind = "Shift+Print";
        name = "Area → file";
      };
      clip = {
        keybind = "Ctrl+Print";
        name = "Area → clipboard";
      };
    };

    # Actions
    actions = {
      kill = {
        keybind = "$mod+c";
        name = "Kill window";
        sway = "kill";
        hypr = "killactive,";
      };
      launcher = {
        keybind = "$mod+d";
        name = "App launcher";
        cmd = "system-menu";
      };
      bookmarks = {
        keybind = "$mod+m";
        name = "Bookmarks";
        cmd = "bookmarks";
      };
      projects = {
        keybind = "$mod+p";
        name = "Projects";
        cmd = "projects";
      };
      projectsCtwo = {
        keybind = "$mod+Shift+p";
        name = "Projects (CTwo)";
        cmd = "projects-ctwo";
      };
      wallpaper = {
        keybind = "$mod+Shift+w";
        name = "Change wallpaper";
        sway = "exec ${path}wallpaper";
        hypr = "exec, wallpaper-manager";
      };
      lock = {
        keybind = "$mod+Ctrl+q";
        name = "Lock screen";
        sway = "exec ${path}swaylock --image $(cat ~/.cache/style/current_wallpaper)";
        hypr = "exec, $lock";
      };
      theme = {
        keybind = "$mod+Shift+Ctrl+t";
        name = "Toggle theme";
        cmd = "toggle-theme";
      };
      keybinds = {
        keybind = "$mod+Shift+y";
        name = "Show keybinds";
        cmd = "keybinds";
      };
      network = {
        keybind = "$mod+Shift+i";
        name = "Network manager";
        sway = "exec ${path}foot -a network sh -c ${path}gazelle";
        hypr = "exec, foot -a network sh -c ~/.nix-profile/bin/gazelle";
      };
      reload = {
        keybind = "$mod+Shift+c";
        name = "Reload config";
        sway = "reload";
        hypr = "exec, hyprctl reload";
      };
      exit = {
        keybind = "$mod+Shift+e";
        name = "Exit session";
        sway = "exec ${path}swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' '${path}swaymsg exit'";
        hypr = "exit,";
      };
    };
  };
in {
  imports = [
    (import ./sway.nix vars)
    (import ./hyprland.nix vars)
  ];

  options.keybinds = {
    runOrRaiseApps = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
    };
    screenshots = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
    };
    actions = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
      default = {};
    };
  };

  config.keybinds = {inherit (vars) runOrRaiseApps screenshots actions;};
}
