# configuration/home-configuration/playa-el-yaque/default.nix
{pkgs, ...}: {
  imports = [
    # ui: sway, waybar, wallpapers, themes, and wofi
    ./../../../home/modules/ui/sway
    ./../../../home/modules/ui/waybar
    ./../../../home/modules/ui/wallpapers
    ./../../../home/modules/ui/themes
    ./../../../home/modules/ui/wofi
    # browsers
    ./../../../home/modules/browsers
    # terminals
    ./../../../home/modules/terminals
    # tui
    ./../../../home/modules/tui/gazelle
    # ai: opencode
    ./../../../home/modules/ai
    # packages
    ./packages.nix
    # programs
    ./programs.nix
    # home-manager user
    ./../../../home/users/nix
  ];

  targets.genericLinux.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr];
    config = {
      sway = {default = ["gtk"];};
    };
  };
  fonts.fontconfig.enable = true;
}
