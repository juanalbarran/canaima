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
    ./../../modules/ai
    ./../../modules/tui/gazelle
    ./../../modules/ui/themes
  ];

  home = {
    username = "juan-albarran";
    homeDirectory = "/home/juan-albarran/";
    stateVersion = "25.11";
    sessionPath = [
      "$HOME/.nix-profile/bin"
    ];
  };

  xsession.enable = true;

  features.bluetooth = false;
  host.isNixOS = true;
  targets.genericLinux.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
    config = {
      sway = {default = ["gtk"];};
    };
  };

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };
}
