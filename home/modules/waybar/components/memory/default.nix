# home/modules/waybar/components/memory/default.nix
{
  programs.waybar.settings.mainBar."memory" = {
    interval = "10";
    format = "";
    format-alt = " {percentage}%";
    max-length = "10";
    tooltip = true;
    tooltip-format = "Memory: {percentage}% used\n{used:0.1f}GiB / {total:0.1f}GiB";
  };
}
