# home/modules/hyprland/default.nix
{
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
    "hypr/hyprland-monitors.conf".source = ./hyprland-monitors.conf;
    "hypr/hyprland-programs.conf".source = ./hyprland-programs.conf;
    "hypr/hyprland-autostart.conf".source = ./hyprland-autostart.conf;
    "hypr/hyprland-keybinds.conf".source = ./hyprland-keybinds.conf;
    "hypr/hyprland-workspaces.conf".source = ./hyprland-workspaces.conf;
  };
}
