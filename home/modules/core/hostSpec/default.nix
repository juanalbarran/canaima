# home/modules/core/hostSpec/default.nix
{lib, ...}: {
  options.hostSpec = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the host";
    };
    fullname = lib.mkOption {
      type = lib.types.str;
      description = "The fullname of the user";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the host";
    };
    email = lib.mkOption {
      type = lib.types.str;
      description = "The email of the user";
    };
    sshKeyName = lib.mkOption {
      type = lib.types.str;
      description = "The name of the ssh keys of the user";
    };
    terminal = lib.mkOption {
      type = lib.types.str;
      description = "The name of the default terminal";
    };
    terminalAppId = lib.mkOption {
      type = lib.types.str;
      description = "The name of the terminal app";
    };
    auxTerminal = lib.mkOption {
      type = lib.types.str;
      default = "ghostty";
      description = "The auxiliary terminal launch command (no path prefix)";
    };
    auxTerminalAppId = lib.mkOption {
      type = lib.types.str;
      default = "com.mitchellh.ghostty";
      description = "The auxiliary terminal app_id for window matching";
    };
    ai = lib.mkOption {
      type = lib.types.str;
      default = "firefoxpwa site launch 01KS5C2YJE85WR6YP8K4Q584CZ";
      description = "The AI assistant launch command (no path prefix)";
    };
    aiAppId = lib.mkOption {
      type = lib.types.str;
      default = "FFPWA-01KS5C2YJE85WR6YP8K4Q584CZ";
      description = "The AI assistant app_id for window matching";
    };
    browser = lib.mkOption {
      type = lib.types.str;
      default = "qutebrowser --target window";
      description = "The default browser launch command (no path prefix)";
    };
    browserAppId = lib.mkOption {
      type = lib.types.str;
      default = "org.qutebrowser.qutebrowser";
      description = "The browser app_id for window matching";
    };
    menu = lib.mkOption {
      type = lib.types.str;
      description = "The default menu to be used (icluyes the command)";
    };
    isNixOS = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set to true if running on NixOS, false for Other";
    };
    windowManager = lib.mkOption {
      type = lib.types.enum ["sway" "hyprland"];
      default = "sway";
      description = "Active window manager; controls workspace modules and terminal selection";
    };
    bluetooth = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Bluetooth Waybar module";
    };
    vpn = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VPN Waybar module";
    };
  };
}
