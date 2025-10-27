# home/modules/hyprland/default.nix
{ pkgs, ... }:
{
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../assets/wallpapers;
      recursive = true;
    };
  };
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
    "hypr/hyprland-monitors.conf".source = ./hyprland-monitors.conf;
    "hypr/hyprland-programs.conf".source = ./hyprland-programs.conf;
    "hypr/hyprland-autostart.conf".source = ./hyprland-autostart.conf;
    "hypr/hyprland-keybinds.conf".source = ./hyprland-keybinds.conf;
    "hypr/hyprland-workspaces.conf".source = ./hyprland-workspaces.conf;
    "hypr/scripts/wallpaper.sh" = {
      executable = true;
      source = pkgs.substituteAll {
        src = ./hyprland-wallpaper.sh.in;
        bash = pkgs.bash;
        coreutils = pkgs.coreutils;
        findutils = pkgs.findutils;
        swww = pkgs.swww;
        libnotify = pkgs.libnotify;
      };
    };
  };
}
