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
    execBinds =
      lib.mapAttrs' (_: b: lib.nameValuePair (toSway b.bind) "exec ${b.command}")
      (config.ui.apps // config.ui.binds);
    actionBinds = {
      ${toSway config.ui.actions.close} = "kill";
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
        keybindings = lib.mkOptionDefault (execBinds // actionBinds);
        startup = map (command: {inherit command;}) config.ui.startup;
      };
    };
  };
}
