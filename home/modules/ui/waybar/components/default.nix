# home/modules/waybar/components/default.nix
{
  config,
  lib,
  ...
}: {
  imports = [
    ./clock
    ./workspaces
    #./memory
    #./cpu
    ./bluetooth
    ./battery
    ./network
    ./pulseaudio
    ./vpn
  ];

  programs.waybar.settings.mainBar.modules-right =
    (lib.optionals config.features.bluetooth ["bluetooth"])
    ++ (lib.optionals config.features.vpn ["custom/vpn"])
    ++ ["pulseaudio" "network" "battery"];
  # modules-right = ["network" "cpu" "memory" "battery"];
}
