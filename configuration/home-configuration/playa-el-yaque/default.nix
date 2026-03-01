# configuration/home-configuration/playa-el-yaque/default.nix
{pkgs, ...}: {
  imports = [
    # core: gc, ssh, sops, hostSpec, package, programs
    ./../../../home/modules/core
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
    # ai: opencode
    ./../../../home/modules/ai
    # network: openvpn, gazelle
    ./../../../home/modules/openvpn
    ./../../../home/modules/tui/gazelle
    # home-manager user
    ./../../../home/users/nix
    # work
    ./../../../home/modules/salesforce
  ];
  features.vpn = true;
  # features.bluetooth = true;

  hostSpec = {
    username = "juan-albarran";
    fullname = "Juan Albarran";
    email = "work/email";
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
