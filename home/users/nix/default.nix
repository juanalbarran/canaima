# home/user/nix/default.nix
{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./packages.nix
    ./programs.nix
    ./../../modules/ghostty
    ./../../modules/starship
    ./../../modules/fastfetch
    ./../../modules/sway
    ./../../modules/hyprlock
    ./../../modules/kanshi
    ./../../modules/wallpapers
    ./../../modules/quickshell
    ./../../modules/keybinds
  ];

  home = {
    username = "juan-albarran";
    homeDirectory = "/home/juan-albarran/";
    stateVersion = "25.11";
  };

  xsession.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
    config = {
      sway = {default = ["gtk"];};
    };
  };
}
