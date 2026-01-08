# home/modules/waybar/components/workspaces/workspace-sway.nix
{
  programs.waybar.settings.mainBar."sway/workspaces" = {
    disable-scroll = true;
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
  };
}
