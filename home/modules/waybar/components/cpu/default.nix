# home/modules/waybar/components/cpu/default.nix
{
  programs.waybar.settings.mainBar."cpu" = {
    interval = 10;
    format = " ";
    format-alt = " {usage}%";
    max-length = 10;
    tooltip = true;
    tooltip-format = "CPU: {usage}%\n\n{icon0}{icon1}{icon2}{icon3}\n{icon4}{icon5}{icon6}{icon7}";
    format-icons = [" " "▂" "▃" "▄" "▅" "▆" "▇" "█"];
  };
}
