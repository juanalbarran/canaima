# home/modules/waybar/components/default.nix
{
  imports = [
    ./clock
    ./workspaces
    #./memory
    #./cpu
    #./bluetooth
    ./battery
    ./network
  ];

  programs.waybar.settings.mainBar.modules-right = ["network" "battery"];
  # modules-right = ["network" "cpu" "memory" "battery"];
}
