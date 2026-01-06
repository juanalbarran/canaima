# home/modules/waybar/components/default.nix
{
  imports = [
    ./clock
    ./workspaces
    ./memory
  ];

  programs.waybar.settings.mainBar = {
    modules-right = ["memory" "cpu" "battery" "network"];
  };
}
