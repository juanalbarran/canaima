# ./modules/ui/wmspecs.nix
{lib, ...}: let
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
