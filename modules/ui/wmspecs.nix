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
            workspace = lib.mkOption {
              type = lib.types.nullOr lib.types.ints.positive;
              default = null;
              description = "Workspace the app's windows always open on; null opens them where you are";
            };
            inherit bind;
          };
        });
        default = {};
        description = "Applications that can be opened by the WM in a run-or-raise action; feature modules add their own";
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
      actions.reload = lib.mkOption {
        type = lib.types.submodule {options = bind;};
        default = {
          mods = ["mod" "shift"];
          key = "c";
        };
        description = "Keybind that reloads the WM config, which reruns ui.reload";
      };
      actions.passthrough = lib.mkOption {
        type = lib.types.submodule {options = bind;};
        default = {
          mods = ["mod" "shift"];
          key = "p";
        };
        description = "Keybind that toggles passthrough, which sends every other key to the focused window so games can bind mod combos";
      };
      startup = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Commands the WM runs once when the session starts";
      };
      reload = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Commands the WM runs when the session starts and again on every config reload";
      };
      session.command = lib.mkOption {
        type = lib.types.str;
        default = "sway";
      };
    };
    # The apps every preset has, set as config rather than as the option's
    # default: a default is dropped as soon as any module adds an app (chrome,
    # slack…). mkDefault on each field still lets a host change one of them
    config.ui.apps = {
      terminal = {
        command = lib.mkDefault "foot";
        appId = lib.mkDefault "foot";
        workspace = lib.mkDefault 1;
        bind.key = lib.mkDefault "q";
      };
      auxTerminal = {
        command = lib.mkDefault "ghostty";
        appId = lib.mkDefault "com.mitchellh.ghostty";
        bind = {
          mods = lib.mkDefault ["mod" "shift"];
          key = lib.mkDefault "q";
        };
      };
      browser = {
        command = lib.mkDefault "qutebrowser";
        appId = lib.mkDefault "org.qutebrowser.qutebrowser";
        workspace = lib.mkDefault 2;
        bind.key = lib.mkDefault "b";
      };
    };
  };
in {
  flake.modules.nixos.ui = wmspecs;
  flake.modules.homeManager.ui = wmspecs;
}
