# home/modules/waybar/components/battery/default.nix
{
  programs.waybar.settings.mainBar."battery" = {
    interval = 60;

    # 1. Define thresholds to match your QML logic
    states = {
      warning = 30; # Matches yellowColor < 0.3
      critical = 20; # Matches lowColor <= 0.2
    };

    # 2. Format: Matches your "Icon + Text" layout
    format = "{icon} {capacity}%";

    # 3. Icons: Matches your QML logic
    # Charging always shows lightning
    format-charging = "󰂄 {capacity}%";
    # Your QML uses one static icon for discharge, but allows color to change
    format-icons = [
      "󰁺" # f007a (10%)
      "󰁻" # f007b
      "󰁼" # f007c
      "󰁽" # f007d
      "󰁿" # f007f
      "󰂀" # f0080
      "󰂁" # f0081
      "󰂂" # f0082
      "󰁹" # f0079 (Full)
    ];

    # Optional: Tooltip
    tooltip-format = "{timeTo} ({capacity}%)";
  };
}
