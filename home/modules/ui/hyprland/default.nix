# home/modules/hyprland/default.nix
{pkgs, ...}: {
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
  };

  home.packages = with pkgs; [
    grim
    slurp
  ];
}
