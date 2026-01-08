# home/modules/ui/waybar/components/pulseaudio/default.nix
{pkgs, ...}: {
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

    on-click = "ghostty --config-file=\"$HOME/.config/ghostty/window-rules/pulsemixer.toml\" -e sh -c \"sleep 0.5 && $HOME/.nix-profile/bin/pulsemixer\"";
    on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
    tooltip-format = "{desc}\n{volume}%";
  };
  home.packages = with pkgs; [pulsemixer];
}
