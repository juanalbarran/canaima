# home/modules/ui/themes/default.nix
{pkgs, ...}: let
  toggle-theme = pkgs.writeShellScriptBin "toggle-theme" (builtins.readFile ./scripts/toggle-theme.sh);
  darkScheme = import ./dark.nix;
  lightScheme = import ./light.nix;
  mkWaybarVars = import ./templates/waybar.nix;
in {
  xdg.configFile = {
    "themes/dark/waybar.css".text = mkWaybarVars darkScheme;
    "themes/light/waybar.css".text = mkWaybarVars lightScheme;
  };
  home.packages = [
    toggle-theme
  ];
}
