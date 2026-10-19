# ./modules/ui/sway-generic-linux.nix
{
  flake.modules.homeManager.sway = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # GDM lists only the sessions in /usr/share/wayland-sessions, never the
    # ones in ~/.local/share, so this one has to be copied there with sudo
    session = pkgs.writeText "sway.desktop" ''
      [Desktop Entry]
      Name=Sway
      Comment=An i3-compatible Wayland compositor
      Exec=${config.home.profileDirectory}/bin/sway-session
      Type=Application
      DesktopNames=sway
    '';
    target = "/usr/share/wayland-sessions/sway.desktop";
    # GDM runs Exec without a login shell, so sway got the distro PATH and
    # nothing from ~/.nix-profile (quickshell, swaymsg, Nix's foot). Sourcing
    # the session vars brings in nix.sh too. In the profile, not the store,
    # so the installed session file stays valid across generations
    sway-session = pkgs.writeShellScriptBin "sway-session" ''
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
      exec "${config.home.profileDirectory}/bin/sway" "$@"
    '';
  in
    lib.mkIf (!config.hostspec.isNixOS) {
      home.packages = [sway-session];
      home.activation.checkSwaySession = lib.hm.dag.entryAnywhere ''
        if ! cmp -s ${session} ${target}; then
          warnEcho "GDM's Sway session is missing or outdated, run"
          warnEcho "  sudo install -Dm644 ${session} ${target}"
        fi
      '';
      # The distro's portals (apt: xdg-desktop-portal-wlr and -gtk), Nix's
      # aren't found by its xdg-desktop-portal. gtk for file pickers, wlr
      # for screen sharing and screenshots, which gtk can't do on Sway
      xdg.configFile."xdg-desktop-portal/sway-portals.conf".text = lib.generators.toINI {} {
        preferred = {
          default = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
        };
      };
    };
}
