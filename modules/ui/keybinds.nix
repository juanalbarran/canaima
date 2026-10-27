# ./modules/ui/keybinds.nix
# The sarisarinama keybinds pane: mod+? opens its menu, a row per app. The
# Sway section is built from ui.apps, ui.binds and Sway's final keybinding
# table, so it shows what is really bound, defaults included. tmux gets the
# binds multiplexer.nix adds on top of the defaults sarisarinama ships.
{
  flake.modules.homeManager.shell = {
    config,
    lib,
    ...
  }: let
    cfg = config.programs.sarisarinama;
    path = "${cfg.package}/share/sarisarinama";
    menu = "${config.xdg.configHome}/sarisarinama/keybinds.json";

    # Sway's name for each modifier, to find the ui.* binds in its table
    modKey =
      {
        alt = "Mod1";
        super = "Mod4";
      }.${
        config.ui.mod
      };
    swayMods = {
      mod = modKey;
      shift = "Shift";
      ctrl = "Control";
    };
    toSway = bind: lib.concatStringsSep "+" (map (m: swayMods.${m}) bind.mods ++ [bind.key]);

    # How a key is printed on a keycap; a letter is printed upper case. No
    # spaces or +: in the pane's notation a space separates keys pressed in
    # turn and + joins a chord
    keyNames = {
      Mod1 = "Alt";
      Mod4 = "Super";
      Control = "Ctrl";
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
      keys = keysOf (toSway app.bind);
      description =
        humanize name
        + lib.optionalString (app.workspace != null) " · workspace ${toString app.workspace}";
    };
    bindRow = name: b: {
      keys = keysOf (toSway b.bind);
      description = humanize name;
    };
    # Binds without the mod key are the keyboard's own: media, Print
    hasMod = b: lib.elem "mod" b.bind.mods;

    # The rest of Sway's table: its defaults and ui.actions. Each command
    # is reduced to a template, a number becoming N and a direction DIR,
    # so mod+1…9 or mod+h/j/k/l make one row each
    taken = map (x: toSway x.bind) (lib.attrValues config.ui.apps ++ lib.attrValues config.ui.binds);
    table =
      lib.filterAttrs (combo: command: command != null && !(lib.elem combo taken))
      config.wayland.windowManager.sway.config.keybindings;
    directions = ["left" "down" "up" "right"];
    templateOf = command: let
      words = lib.splitString " " command;
      last = lib.last words;
      swap = w:
        if lib.elem w directions
        then "DIR"
        else if builtins.match "[0-9]+" w != null
        then "N"
        else w;
    in
      if lib.hasPrefix "exec " command
      then command
      else lib.concatStringsSep " " (lib.init words ++ [(swap last)]);

    # template -> [group, description]; anything else lands in Other
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
    describe = command: let
      t = templateOf command;
    in
      known.${
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
    swayGroup = title: {
      inherit title;
      binds = lib.sort (a: b: a.description < b.description) (map (r: r.bind) (lib.filter (r: r.group == title) rows));
    };
  in {
    ui.binds.keybinds = {
      command = "quickshell -p ${path} ipc call shell toggle menu ${lib.escapeShellArg (builtins.toJSON {file = menu;})}";
      # mod+?: mod+k stays Sway's focus up
      bind = {
        mods = ["mod" "shift"];
        key = "slash";
      };
    };

    programs.sarisarinama.keybinds = {
      sway = {
        label = "Sway";
        icon = " ";
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
          ++ map swayGroup ["Windows" "Layout" "Workspaces" "Session" "Other"];
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
      # alt, its Alt+1…9 tabs never arrive: Sway takes them for workspaces
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
              description = "Sway's workspaces, not tabs";
            };
        }
      ];
    };
  };
}
