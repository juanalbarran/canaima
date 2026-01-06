# home/modules/waybar/components/clock/default.nix
{
  programs.waybar.settings.mainBar = {
    modules-center = ["clock"];
    "clock" = {
      format = "{:%H:%M | %a, %d}";
    };
  };
}
