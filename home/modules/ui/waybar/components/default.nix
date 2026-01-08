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
    ./pulseaudio
  ];

  programs.waybar.settings.mainBar.modules-right = ["pulseaudio" "network" "battery"];
  # modules-right = ["network" "cpu" "memory" "battery"];
}
