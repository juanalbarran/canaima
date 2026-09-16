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
    toSway = bind:
      lib.concatStringsSep "+"
      (map (m:
          if m == "mod"
          then modKey
          else m)
        bind.mods
        ++ [bind.key]);
    appBinds =
      lib.mapAttrs' (_: app: lib.nameValuePair (toSway app.bind) "exec ${app.command}")
      config.ui.apps;
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
        keybindings = lib.mkOptionDefault appBinds;
      };
    };
  };
}
