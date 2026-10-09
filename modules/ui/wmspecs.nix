# ./modules/ui/wmspecs.nix
{lib, ...}: let
  bind = {
    mods = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["mod" "shift" "ctrl"]);
      default = ["mod"];
      description = "Modifiers of the keybind; 'mod' resolves to ui.mod";
    };
    key = lib.mkOption {
      type = lib.types.str;
      description = "Key for the keybind";
    };
  };
  wmspecs = {
    options.ui = {
      mod = lib.mkOption {
        type = lib.types.enum ["alt" "super"];
        default = "alt";
        description = "Semantic modifier key; each WM translates to its own dialect";
      };
      apps = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            command = lib.mkOption {
              type = lib.types.str;
              description = "Command to launch the application";
            };
            appId = lib.mkOption {
              type = lib.types.str;
              description = "Wayland app_id, used to match windows for run-or-raise";
            };
            inherit bind;
          };
        });
        default = {
          terminal = {
            command = "foot";
            appId = "foot";
            bind.key = "q";
          };
          auxTerminal = {
            command = "ghostty";
            appId = "com.mitchellh.ghostty";
            bind = {
              mods = ["mod" "shift"];
              key = "q";
            };
          };
          browser = {
            command = "qutebrowser";
            appId = "org.qutebrowser.qutebrowser";
            bind.key = "b";
          };
        };
        description = "Applications that can be opened by the WM in a run-or-raise action";
      };
      binds = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            command = lib.mkOption {
              type = lib.types.str;
              description = "Command the keybind runs";
            };
            inherit bind;
          };
        });
        default = {};
        description = "Keybinds that run a command, without run-or-raise";
      };
      actions.close = lib.mkOption {
        type = lib.types.submodule {options = bind;};
        default.key = "c";
        description = "Keybind that closes the focused window";
      };
      startup = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Commands the WM runs once when the session starts";
      };
      session.command = lib.mkOption {
        type = lib.types.str;
        default = "sway";
      };
    };
  };
in {
  flake.modules.nixos.ui = wmspecs;
  flake.modules.homeManager.ui = wmspecs;
}
