# ./modules/ui/keybinds.nix
# The sarisarinama keybinds pane: mod+? opens its menu, a row per app. The
# WM section, Sway or Hyprland, whichever is enabled, is built from ui.apps,
# ui.binds and that WM's final keybinding table, so it shows what is really
# bound, defaults included. tmux gets the binds multiplexer.nix adds on top
# of the defaults sarisarinama ships.
{
  flake.modules.homeManager.shell = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.sarisarinama;
    path = "${cfg.package}/share/sarisarinama";
    menu = "${config.xdg.configHome}/sarisarinama/keybinds.json";

    hyprland = config.wayland.windowManager.hyprland;

    # Hyprland's bind lines as the combo -> command table Sway has:
    # "ALT SHIFT, h, movewindow, l" -> {"ALT+SHIFT+h" = "movewindow l";}
    hyprTable = lib.listToAttrs (map (line: let
      f = map lib.trim (lib.splitString "," line);
      mods = lib.filter (m: m != "") (lib.splitString " " (lib.head f));
    in
      lib.nameValuePair
      (lib.concatStringsSep "+" (mods ++ [(lib.elemAt f 1)]))
      (lib.trim "${lib.elemAt f 2} ${lib.concatStringsSep ", " (lib.drop 3 f)}"))
    (hyprland.settings.bind or []));

    # The running WM: its names for the modifiers, to find the ui.* binds
    # in its table, the table itself, and what its commands mean
    wm =
      if hyprland.enable
      then {
        name = "hyprland";
        label = "Hyprland";
        icon = " "; # nf-linux-hyprland
        mods = {
          mod = lib.toUpper config.ui.mod;
          shift = "SHIFT";
          ctrl = "CTRL";
        };
        table = hyprTable;
        directions = ["l" "d" "u" "r"];
        known = {
          "movefocus DIR" = ["Windows" "Focus a window"];
          "movewindow DIR" = ["Windows" "Move the window"];
          "killactive" = ["Windows" "Close the window"];
          "fullscreen" = ["Windows" "Fullscreen"];
          "togglefloating" = ["Windows" "Float or tile the window"];
          "movetoworkspacesilent special:scratchpad" = ["Windows" "Send to the scratchpad"];
          "togglespecialworkspace scratchpad" = ["Windows" "Show the scratchpad"];
          "layoutmsg togglesplit" = ["Layout" "Toggle the split direction"];
          "togglegroup" = ["Layout" "Group the windows (tabbed)"];
          "submap resize" = ["Layout" "Resize mode"];
          "workspace N" = ["Workspaces" "Go to workspace"];
          "movetoworkspacesilent N" = ["Workspaces" "Move the window to workspace"];
          "exec hyprctl reload" = ["Session" "Reload Hyprland"];
          "submap passthrough" = ["Session" "Passthrough: every key to the window"];
        };
      }
      else {
        name = "sway";
        label = "Sway";
        icon = " ";
        mods = {
          mod =
            {
              alt = "Mod1";
              super = "Mod4";
            }.${
              config.ui.mod
            };
          shift = "Shift";
          ctrl = "Control";
        };
        table = config.wayland.windowManager.sway.config.keybindings;
        directions = ["left" "down" "up" "right"];
        known = {
          "focus DIR" = ["Windows" "Focus a window"];
          "move DIR" = ["Windows" "Move the window"];
          "kill" = ["Windows" "Close the window"];
          "fullscreen toggle" = ["Windows" "Fullscreen"];
          "floating toggle" = ["Windows" "Float or tile the window"];
          "focus mode_toggle" = ["Windows" "Focus floating or tiled"];
          "focus parent" = ["Windows" "Focus the parent"];
          "move scratchpad" = ["Windows" "Send to the scratchpad"];
          "scratchpad show" = ["Windows" "Show the scratchpad"];
          "layout toggle split" = ["Layout" "Toggle the split direction"];
          "layout tabbed" = ["Layout" "Tabbed"];
          "layout stacking" = ["Layout" "Stacked"];
          "splitv" = ["Layout" "Split vertically"];
          "splith" = ["Layout" "Split horizontally"];
          "mode resize" = ["Layout" "Resize mode"];
          "workspace number N" = ["Workspaces" "Go to workspace"];
          "move container to workspace number N" = ["Workspaces" "Move the window to workspace"];
          "reload" = ["Session" "Reload Sway"];
          "mode passthrough" = ["Session" "Passthrough: every key to the window"];
        };
      };
    # A ui.* bind the way the WM's table writes it: "Mod1+Shift+q", "ALT+SHIFT+q"
    toCombo = bind: lib.concatStringsSep "+" (map (m: wm.mods.${m}) bind.mods ++ [bind.key]);

    # How a key is printed on a keycap; a letter is printed upper case. No
    # spaces or +: in the pane's notation a space separates keys pressed in
    # turn and + joins a chord
    keyNames = {
      Mod1 = "Alt";
      Mod4 = "Super";
      Control = "Ctrl";
      ALT = "Alt";
      SUPER = "Super";
      SHIFT = "Shift";
      CTRL = "Ctrl";
      Return = "Enter";
      Escape = "Esc";
      space = "Space";
      minus = "-";
      plus = "Plus";
      slash = "/";
      question = "?";
      Left = "←";
      Down = "↓";
      Up = "↑";
      Right = "→";
      Print = "PrtSc";
      XF86AudioRaiseVolume = "Vol↑";
      XF86AudioLowerVolume = "Vol↓";
      XF86AudioMute = "Mute";
      XF86AudioMicMute = "MicMute";
      XF86MonBrightnessUp = "Bright↑";
      XF86MonBrightnessDown = "Bright↓";
    };
    keyName = k:
      keyNames.${
        k
      } or (
        if builtins.stringLength k == 1
        then lib.toUpper k
        else lib.removePrefix "XF86" k
      );
    # "Mod1+Shift+q" -> "Alt+Shift+Q", in the pane's notation
    keysOf = combo: lib.concatStringsSep "+" (map keyName (lib.splitString "+" combo));

    # "auxTerminal" -> "Aux terminal"
    humanize = name: let
      spaced = lib.concatMapStrings (c:
        if c != lib.toLower c
        then " " + lib.toLower c
        else c)
      (lib.stringToCharacters name);
    in
      lib.toUpper (lib.substring 0 1 spaced) + lib.substring 1 (-1) spaced;

    appRow = name: app: {
      keys = keysOf (toCombo app.bind);
      description =
        humanize name
        + lib.optionalString (app.workspace != null) " · workspace ${toString app.workspace}";
    };
    bindRow = name: b: {
      keys = keysOf (toCombo b.bind);
      description = humanize name;
    };
    # Binds without the mod key are the keyboard's own: media, Print
    hasMod = b: lib.elem "mod" b.bind.mods;

    # The rest of the WM's table: its defaults and ui.actions. Each command
    # is reduced to a template, a number becoming N and a direction DIR,
    # so mod+1…9 or mod+h/j/k/l make one row each
    taken = map (x: toCombo x.bind) (lib.attrValues config.ui.apps ++ lib.attrValues config.ui.binds);
    table =
      lib.filterAttrs (combo: command: command != null && !(lib.elem combo taken))
      wm.table;
    templateOf = command: let
      words = lib.splitString " " command;
      last = lib.last words;
      swap = w:
        if lib.elem w wm.directions
        then "DIR"
        else if builtins.match "[0-9]+" w != null
        then "N"
        else w;
    in
      if lib.hasPrefix "exec " command
      then command
      else lib.concatStringsSep " " (lib.init words ++ [(swap last)]);

    # template -> [group, description]; anything else lands in Other
    describe = command: let
      t = templateOf command;
    in
      wm.known.${
        t
      } or (
        if lib.hasPrefix "exec swaynag" command
        then ["Session" "Exit Sway"]
        else if lib.hasPrefix "exec " command
        then ["Session" "Run ${baseNameOf (lib.head (lib.splitString " " (lib.removePrefix "exec " command)))}"]
        else ["Other" command]
      );

    # The combos of one template, as one row. The last key varies: 1…9 for
    # numbers, H/J/K/L for directions, with the arrows left out as the
    # same thing twice
    rowOf = combos: let
      lasts = map (c: lib.last (lib.splitString "+" c)) combos;
      prefix = lib.init (lib.splitString "+" (lib.head combos));
      letters = lib.filter (k: builtins.stringLength k == 1) lasts;
      nums = lib.sort lib.lessThan (map lib.toInt (lib.filter (k: builtins.match "[0-9]+" k != null) lasts));
      varying =
        if lib.length combos == 1
        then keyName (lib.head lasts)
        else if nums != []
        then "${toString (lib.head nums)}…${toString (lib.last nums)}"
        else if letters != []
        then lib.concatMapStringsSep "/" keyName letters
        else lib.concatMapStrings keyName lasts;
      d = describe table.${lib.head combos};
    in {
      group = lib.head d;
      bind = {
        keys = lib.concatStringsSep "+" (map keyName prefix ++ [varying]);
        description = lib.last d;
      };
    };
    # Grouped by template and by the modifiers held, so mod+1 and
    # mod+shift+1 stay apart
    rows = map rowOf (lib.attrValues (lib.groupBy (combo:
      templateOf table.${combo}
      + "|"
      + lib.concatStringsSep "+" (lib.init (lib.splitString "+" combo)))
    (lib.attrNames table)));
    wmGroup = title: {
      inherit title;
      binds = lib.sort (a: b: a.description < b.description) (map (r: r.bind) (lib.filter (r: r.group == title) rows));
    };
  in {
    ui.binds.keybinds = {
      command = "quickshell -p ${path} ipc call shell toggle menu ${lib.escapeShellArg (builtins.toJSON {file = menu;})}";
      # mod+?: mod+k stays the WM's focus up
      bind = {
        mods = ["mod" "shift"];
        key = "slash";
      };
    };

    programs.sarisarinama.keybinds = {
      # Only the running WM's section: the other one binds nothing
      ${wm.name} = {
        inherit (wm) label icon;
        order = 30;
        groups =
          [
            {
              title = "Applications";
              binds = lib.mapAttrsToList appRow config.ui.apps;
            }
            {
              title = "Shell";
              binds = lib.mapAttrsToList bindRow (lib.filterAttrs (_: hasMod) config.ui.binds);
            }
            {
              title = "Keyboard keys";
              binds = lib.mapAttrsToList bindRow (lib.filterAttrs (_: b: !hasMod b) config.ui.binds);
            }
          ]
          ++ map wmGroup ["Windows" "Layout" "Workspaces" "Session" "Other"];
      };

      # What multiplexer.nix binds beyond tmux's defaults
      tmux.groups = lib.mkAfter [
        {
          title = "Canaima";
          binds = [
            {
              keys = "Ctrl+h/j/k/l";
              description = "Pane, or nvim split, that way";
            }
            {
              keys = "Ctrl+Alt+h/j/k/l";
              description = "Resize the pane";
            }
            {
              keys = "Alt+{";
              description = "Previous window";
            }
            {
              keys = "Alt+}";
              description = "Next window";
            }
            {
              keys = "Ctrl+Alt+{";
              description = "Move the window left";
            }
            {
              keys = "Ctrl+Alt+}";
              description = "Move the window right";
            }
            {
              keys = "Ctrl+b X";
              description = "Kill the session";
            }
            {
              keys = "v";
              description = "Start a selection (copy mode)";
            }
            {
              keys = "y";
              description = "Copy and leave (copy mode)";
            }
          ];
        }
      ];

      # What terminal.nix binds beyond foot's defaults
      foot.groups = lib.mkAfter [
        {
          title = "Canaima";
          binds = [
            {
              keys = "Ctrl+Enter";
              description = "Fullscreen";
            }
            {
              keys = "Ctrl+Shift+y";
              description = "Copy a URL";
            }
            {
              keys = "Ctrl+Shift+g";
              description = "Copy a commit hash";
            }
            {
              keys = "Shift+Enter";
              description = "Told apart from Enter (Claude Code)";
            }
          ];
        }
      ];

      # What aux-terminal.nix binds beyond ghostty's defaults. With mod =
      # alt, its Alt+1…9 tabs never arrive: the WM takes them for workspaces
      ghostty.groups = lib.mkAfter [
        {
          title = "Canaima";
          binds =
            [
              {
                keys = "Alt+{";
                description = "Previous tab, or tmux's window";
              }
              {
                keys = "Alt+}";
                description = "Next tab, or tmux's window";
              }
            ]
            ++ lib.optional (config.ui.mod == "alt") {
              keys = "Alt+1…9";
              description = "${wm.label}'s workspaces, not tabs";
            };
        }
      ];
    };
  };
}
