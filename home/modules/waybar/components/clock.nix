# home/modules/waybar/components/clock.nix
{
  programs.waybar.settings.mainBar = {
    modules-center = ["clock"];
    "clock" = {
      format = "{:%H:%M | %a, %d}";
    };
  };
}
