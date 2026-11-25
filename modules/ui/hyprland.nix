# ./modules/ui/hyprland.nix
# Hyprland: the same ui.* options sway.nix reads, in Hyprland's dialect.
# Run-or-raise apps, ui.binds, ui.actions, workspaces and startup come from
# ui.*; the window binds mirror Sway's defaults, so both WMs feel the same
{
  flake.modules.nixos.hyprland = {
    programs.hyprland.enable = true;
    hardware.graphics.enable = true;
    # Hyprland's own launcher, the one its session file runs
    ui.session.command = "start-hyprland";
  };
  flake.modules.homeManager.hyprland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    hyprMods = {
      mod = lib.toUpper config.ui.mod;
      shift = "SHIFT";
      ctrl = "CTRL";
    };
    # {mods = ["mod" "shift"]; key = "q";} -> "ALT SHIFT, q"
    toHypr = bind: "${lib.concatMapStringsSep " " (m: hyprMods.${m}) bind.mods}, ${bind.key}";
    on = mods: key: toHypr {inherit mods key;};

    # hyprctl from PATH: only the running Hyprland's own copy is sure to
    # speak its protocol. A script, so jq's $c and ; never reach hyprlang
    runOrRaise = name: app:
      pkgs.writeShellScript "raise-${name}" ''
        if hyprctl clients -j | ${lib.getExe pkgs.jq} -e --arg c ${lib.escapeShellArg app.appId} 'any(.[]; .class == $c)' >/dev/null; then
          exec hyprctl dispatch focuswindow ${lib.escapeShellArg "class:^(${app.appId})$"}
        fi
        ${lib.optionalString (app.workspace != null) "hyprctl dispatch workspace ${toString app.workspace} >/dev/null"}
        exec ${app.command}
      '';

    # Sway's default binds in Hyprland's dispatchers. vim keys and arrows
    dirs = {
      h = "l";
      j = "d";
      k = "u";
      l = "r";
      left = "l";
      down = "d";
      up = "u";
      right = "r";
    };
    defaults =
      lib.mapAttrs' (x: d: lib.nameValuePair (on ["mod"] x) "movefocus, ${d}") dirs
      // lib.mapAttrs' (x: d: lib.nameValuePair (on ["mod" "shift"] x) "movewindow, ${d}") dirs
      // lib.listToAttrs (lib.concatMap (n: let
        w = toString n;
      in [
        (lib.nameValuePair (on ["mod"] w) "workspace, ${w}")
        (lib.nameValuePair (on ["mod" "shift"] w) "movetoworkspacesilent, ${w}")
      ]) (lib.range 1 9))
      // {
        ${on ["mod"] "Return"} = "exec, ${config.ui.apps.terminal.command}";
        ${on ["mod"] "f"} = "fullscreen,";
        ${on ["mod" "shift"] "space"} = "togglefloating,";
        ${on ["mod"] "e"} = "layoutmsg, togglesplit";
        # A group is Hyprland's take on Sway's tabbed layout
        ${on ["mod"] "w"} = "togglegroup,";
        ${on ["mod"] "r"} = "submap, resize";
        ${on ["mod" "shift"] "minus"} = "movetoworkspacesilent, special:scratchpad";
        ${on ["mod"] "minus"} = "togglespecialworkspace, scratchpad";
      };
    # Keyed by combo and merged last-wins, as sway.nix does: an app or a
    # ui.binds on a default's key replaces it. Two Hyprland binds on one
    # key would both fire
    binds =
      defaults
      // lib.mapAttrs' (name: a: lib.nameValuePair (toHypr a.bind) "exec, ${runOrRaise name a}") config.ui.apps
      // lib.mapAttrs' (_: b: lib.nameValuePair (toHypr b.bind) "exec, ${b.command}") config.ui.binds
      // {
        ${toHypr config.ui.actions.close} = "killactive,";
        ${toHypr config.ui.actions.reload} = "exec, hyprctl reload";
        ${toHypr config.ui.actions.passthrough} = "submap, passthrough";
      };
    resize = {
      h = "-10 0";
      j = "0 10";
      k = "0 -10";
      l = "10 0";
      left = "-10 0";
      down = "0 10";
      up = "0 -10";
      right = "10 0";
    };
  in {
    wayland.windowManager.hyprland = {
      enable = true;
      # On NixOS, programs.hyprland already installs both
      package = lib.mkIf config.hostspec.isNixOS null;
      portalPackage = lib.mkIf config.hostspec.isNixOS null;
      # Home Manager 26.05 defaults to Lua. hyprlang keeps `hyprctl keyword`
      # and `hyprctl dispatch <name>` working, which sarisarinama uses
      configType = "hyprlang";
      settings = {
        bind = lib.mapAttrsToList (combo: action: "${combo}, ${action}") binds;
        # Drag and resize floating windows, Sway's floating_modifier
        bindm = [
          "${hyprMods.mod}, mouse:272, movewindow"
          "${hyprMods.mod}, mouse:273, resizewindow"
        ];
        # Sway's assign: the app's windows open on its workspace, without
        # switching there
        windowrule =
          map (a: "match:class ^(${a.appId})$, workspace ${toString a.workspace} silent")
          (lib.filter (a: a.workspace != null) (lib.attrValues config.ui.apps));
        "exec-once" = config.ui.startup;
        # exec reruns on every reload, Sway's exec_always
        exec = config.ui.reload;
        # Sway's look: no borders, gaps, rounding or animations
        general = {
          border_size = 0;
          gaps_in = 0;
          gaps_out = 0;
        };
        decoration.rounding = 0;
        animations.enabled = false;
        # sarisarinama draws the wallpaper
        misc = {
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
        };
      };
      submaps = {
        # Only its own toggle, so every other key reaches the window
        passthrough.settings.bind = ["${toHypr config.ui.actions.passthrough}, submap, reset"];
        resize.settings = {
          binde = lib.mapAttrsToList (x: d: ", ${x}, resizeactive, ${d}") resize;
          bind = [
            ", Escape, submap, reset"
            ", Return, submap, reset"
          ];
        };
      };
    };
  };
}
