# home/modules/ui/waybar/components/pulseaudio/default.nix
{
  pkgs,
  config,
  ...
}: let
  isHyprland = config.wayland.windowManager.hyprland.enable;
  termCommand =
    if isHyprland
    then "${pkgs.kitty}/bin/kitty --class pulsemixer -e pulsemixer"
    else "${pkgs.foot}/bin/foot -a pulsemixer -e pulsemixer";
in {
  programs.waybar.settings.mainBar."pulseaudio" = {
    scroll-step = 5;
    format = "{icon}";
    format-muted = " ";
    format-bluetooth = " {icon}";
    format-bluetooth-muted = "  ";

    format-icons = {
      default = ["" " " " "];
      headphone = " ";
      hands-free = "";
      headset = "";
      phone = " ";
      portable = " ";
      car = " ";
    };

    on-click = termCommand;
    on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
    tooltip-format = "{desc}\n{volume}%";
  };
  home.packages = with pkgs; [pulsemixer];
}
