# hosts/modules/ui/sway/default.nix
{pkgs, ...}: {
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
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
      user = "greeter";
    };
  };
}
