# home/user/nix/default.nix
{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./packages.nix
    ./programs.nix
    ./../../modules/kanshi
    ./../../modules/browsers
    ./../../modules/ui/sway
    ./../../modules/ui/wallpapers
    ./../../modules/ui/waybar
    ./../../modules/ui/wofi
    ./../../modules/terminals
  ];

  home = {
    username = "juan-albarran";
    homeDirectory = "/home/juan-albarran/";
    stateVersion = "25.11";
  };

  xsession.enable = true;

  features.bluetooth = false;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
    config = {
      sway = {default = ["gtk"];};
    };
  };
}
