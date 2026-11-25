# ./modules/ui/hyprland-generic-linux.nix
{
  flake.modules.homeManager.hyprland = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # GDM lists only the sessions in /usr/share/wayland-sessions, never the
    # ones in ~/.local/share, so this one has to be copied there with sudo
    session = pkgs.writeText "hyprland.desktop" ''
      [Desktop Entry]
      Name=Hyprland
      Comment=A dynamic tiling Wayland compositor
      Exec=${config.home.profileDirectory}/bin/hyprland-session
      Type=Application
      DesktopNames=Hyprland
    '';
    target = "/usr/share/wayland-sessions/hyprland.desktop";
    # GDM runs Exec without a login shell, so Hyprland would get the distro
    # PATH and nothing from ~/.nix-profile (quickshell, hyprctl, foot).
    # Sourcing the session vars brings in nix.sh too. In the profile, not the
    # store, so the installed session file stays valid across generations.
    # start-hyprland is Hyprland's watchdog launcher, what its own session runs
    hyprland-session = pkgs.writeShellScriptBin "hyprland-session" ''
      . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
      exec "${config.home.profileDirectory}/bin/start-hyprland" "$@"
    '';
  in
    lib.mkIf (!config.hostspec.isNixOS) {
      home.packages = [hyprland-session];
      home.activation.checkHyprlandSession = lib.hm.dag.entryAnywhere ''
        if ! cmp -s ${session} ${target}; then
          warnEcho "GDM's Hyprland session is missing or outdated, run"
          warnEcho "  sudo install -Dm644 ${session} ${target}"
        fi
      '';
      # The distro's portals, as for Sway (apt: xdg-desktop-portal-wlr and
      # -gtk): Nix's xdg-desktop-portal-hyprland isn't found by Ubuntu's
      # xdg-desktop-portal. Picked by XDG_CURRENT_DESKTOP=Hyprland. wlr
      # speaks wlr-screencopy, which Hyprland also implements
      xdg.configFile."xdg-desktop-portal/hyprland-portals.conf".text = lib.generators.toINI {} {
        preferred = {
          default = "gtk";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
        };
      };
    };
}
