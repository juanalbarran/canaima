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
    (lib.optionals config.hostSpec.bluetooth ["bluetooth"])
    ++ (lib.optionals config.hostSpec.vpn ["custom/vpn"])
    ++ ["pulseaudio" "network" "battery"];
  # modules-right = ["network" "cpu" "memory" "battery"];
}
