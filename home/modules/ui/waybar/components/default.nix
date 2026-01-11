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
  ];

  programs.waybar.settings.mainBar.modules-right =
    (lib.optionals config.features.bluetooth ["bluetooth"])
    ++ ["pulseaudio" "network" "battery"];
  # modules-right = ["network" "cpu" "memory" "battery"];
}
