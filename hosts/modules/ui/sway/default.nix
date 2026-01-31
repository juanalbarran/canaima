# hosts/modules/ui/sway/default.nix
{
  pkgs,
  lib,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.sway}/bin/sway";
  username = "juan";
in {
  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    light.enable = true;
  };
  security.polkit.enable = true;
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true; # Wayland reference portal (needed for screensharing)
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  # Login
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${tuigreet} --time --cmd ${session}";
      user = "greeter";
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Fails quietly instead of spamming screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
