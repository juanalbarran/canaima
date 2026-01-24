# home/modules/ui/themes/default.nix
{pkgs, ...}: let
  toggle-theme = pkgs.writeShellScriptBin "toggle-theme" (builtins.readFile ./scripts/toggle-theme.sh);
  darkScheme = import ./dark.nix;
  lightScheme = import ./light.nix;
  mkWaybarVars = import ./templates/waybar.nix;
  mkQuteVars = import ./templates/qutebrowser.nix;
in {
  xdg.configFile = {
    # waybar
    "themes/dark/waybar.css".text = mkWaybarVars darkScheme;
    "themes/light/waybar.css".text = mkWaybarVars lightScheme;

    # qutebrowser
    "themes/dark/qutebrowser.py".text = mkQuteVars darkScheme;
    "themes/light/qutebrowser.py".text = mkQuteVars lightScheme;
  };
  home.packages = [
    toggle-theme
  ];
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaite";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "Sans";
      size = 12;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
