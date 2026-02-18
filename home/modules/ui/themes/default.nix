# home/modules/ui/themes/default.nix
{pkgs, ...}: let
  toggle-theme = pkgs.writeShellScriptBin "toggle-theme" (builtins.readFile ./scripts/toggle-theme.sh);

  # Light / Dark
  darkScheme = import ./dark.nix;
  lightScheme = import ./light.nix;

  # Templates
  mkWaybarVars = import ./templates/waybar.nix;
  mkQuteVars = import ./templates/qutebrowser.nix;
  mkGhosttyVars = import ./templates/ghostty.nix;
  mkWofiVars = import ./templates/wofi.nix;
  mkFootVars = import ./templates/foot.nix;
in {
  xdg.configFile = {
    # waybar
    "themes/dark/waybar.css".text = mkWaybarVars darkScheme;
    "themes/light/waybar.css".text = mkWaybarVars lightScheme;

    # qutebrowser
    "themes/dark/qutebrowser.py".text = mkQuteVars darkScheme;
    "themes/light/qutebrowser.py".text = mkQuteVars lightScheme;

    # ghostty
    "themes/dark/ghostty".text = mkGhosttyVars darkScheme;
    "themes/light/ghostty".text = mkGhosttyVars lightScheme;

    # wofi
    "themes/dark/wofi.css".text = mkWofiVars darkScheme;
    "themes/light/wofi.css".text = mkWofiVars lightScheme;

    # foot
    "themes/dark/foot".text = mkFootVars darkScheme;
    "themes/light/foot".text = mkFootVars lightScheme;
  };
  home.packages = [
    toggle-theme
  ];
  imports = [
    ./gtk.nix
  ];
}
