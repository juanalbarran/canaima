# ./modules/ui/sway.nix
{
  flake.modules.nixos.sway = {pkgs, ...}: {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    hardware.graphics.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
  flake.modules.homeManager.sway = {
    config,
    lib,
    pkgs,
    ...
  }: let
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
    toSway = bind:
      lib.concatStringsSep "+"
      (map (m: swayMods.${m}) bind.mods ++ [bind.key]);
    swaymsg = lib.getExe' pkgs.sway "swaymsg";
    runOrRaise = app: "exec ${swaymsg} '[app_id=\"^${app.appId}$\"] focus' || ${app.command}";
    appBinds =
      lib.mapAttrs' (_: a: lib.nameValuePair (toSway a.bind) (runOrRaise a))
      config.ui.apps;
    execBinds =
      lib.mapAttrs' (_: b: lib.nameValuePair (toSway b.bind) "exec ${b.command}")
      config.ui.binds;
    actionBinds = {
      ${toSway config.ui.actions.close} = "kill";
      ${toSway config.ui.actions.reload} = "reload";
      ${toSway config.ui.actions.passthrough} = "mode passthrough";
    };
  in {
    wayland.windowManager.sway = {
      enable = true;
      package =
        if config.hostspec.isNixOS
        then null
        else pkgs.sway;
      config = {
        modifier = modKey;
        terminal = config.ui.apps.terminal.command;
        bars = [];
        window = {
          border = 0;
          titlebar = false;
        };
        floating = {
          border = 0;
          titlebar = false;
        };
        keybindings = lib.mkOptionDefault (appBinds
          // execBinds
          // actionBinds
          // {
            # Home Manager sorts bindings by name, so Mod+0 came first and
            # Sway named a new screen's first workspace 10. Without it, 1.
            "${modKey}+0" = null;
            "${modKey}+Shift+0" = null;
          });
        # Passthrough has no keybinds but its own exit, so every other key reaches the
        # focused window, mkOptionDefault keeps Sway's default resize mode
        modes = lib.mkOptionDefault {
          passthrough.${toSway config.ui.actions.passthrough} = "mode default";
        };
        startup =
          map (command: {inherit command;}) config.ui.startup
          ++ map (command: {
            inherit command;
            always = true;
          })
          config.ui.reload;
      };
    };
  };
}
