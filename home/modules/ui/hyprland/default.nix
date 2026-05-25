# home/modules/hyprland/default.nix
{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [ ../keybinds ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  xdg.configFile = {
    "hypr/hyprland-monitors.conf".source = ./hyprland-monitors.conf;
    "hypr/hyprland-programs.conf".source = ./hyprland-programs.conf;
    "hypr/hyprland-autostart.conf".source = ./hyprland-autostart.conf;
    "hypr/hyprland-keybinds.conf".source = ./hyprland-keybinds.conf;
    "hypr/hyprland-workspaces.conf".source = ./hyprland-workspaces.conf;
    "hypr/hyprland-rules.conf".source = ./hyprland-rules.conf;
  };
  xdg.dataFile."wayland-sessions/hyprland.desktop" = lib.mkIf (!config.hostSpec.isNixOS) {
    text = ''
      [Desktop Entry]
      Name=Hyprland
      Comment=An intelligent dynamic tiling Wayland compositor
      Exec=${config.home.homeDirectory}/.nix-profile/bin/hyprland
      Type=Application
    '';
  };
  home = {
    packages = with pkgs; [
      grim
      slurp
    ];
    activation.createScreenshotsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/Pictures/screenshots
    '';
  };
}
