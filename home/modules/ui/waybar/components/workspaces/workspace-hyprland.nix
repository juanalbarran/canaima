# home/modules/waybar/components/workspaces/workspace-hyprland.nix
{
  programs.waybar.settings.mainBar."hyprland/workspaces" = {
    active-only = false;
    all-outputs = true;

    persistent-workspaces = {
      "1" = [];
      "2" = [];
      "3" = [];
      "4" = [];
    };

    format = "{icon}";
    format-icons = {
      focused = "";
      default = "󰄰";
      urgent = "";
    };
    on-click = "activate";
  };
}
