# home/modules/hyprlock/default.nix
{
  programs.hyprlock.enable = true;
  xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
}
