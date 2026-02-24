# configuration/home-configuration/playa-el-yaque/default.nix
{pkgs, ...}: {
  imports = [
    ./packages.nix
    ./programs.nix
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
    # config
    ./../../../home/modules/ssh
    ./../../../home/modules/sops
    ./../../../home/modules/hostSpec
    ./../../../home/modules/gc
    ./../../../home/modules/openvpn
    # home-manager user
    ./../../../home/users/nix
  ];
  features.vpn = true;
  # features.bluetooth = true;

  hostSpec = {
    username = "playa-el-yaque";
    hostname = "playa-el-yaque";
    sshKeyName = "playa-el-yaque";
  };

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
