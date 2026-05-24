# home/modules/waybar/components/workspaces/default.nix
{config, ...}: let
  hyprlandEnabled = config.features.windowManager == "hyprland";
in {
  imports = [
    ./workspace-hyprland.nix
    ./workspace-sway.nix
  ];
  programs.waybar.settings.mainBar.modules-left =
    if hyprlandEnabled
    then ["hyprland/workspaces" "hyprland/submap"]
    else ["sway/workspaces" "sway/mode"];
}
