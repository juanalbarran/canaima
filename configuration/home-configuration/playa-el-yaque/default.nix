# configuration/home-configuration/playa-el-yaque/default.nix
{pkgs, ...}: {
  imports = [
    # core: gc, ssh, sops, hostSpec, package, programs
    ./../../../home/modules/core
    # ui: sway, waybar, wallpapers and themes
    ./../../../home/modules/ui/sway
    ./../../../home/modules/ui/waybar
    ./../../../home/modules/ui/wallpapers
    ./../../../home/modules/ui/themes
    # browsers
    ./../../../home/modules/browsers
    # terminals
    ./../../../home/modules/terminals
    # scripts
    ./../../../home/modules/scripts
    # menus, wofi and bemenu
    ./../../../home/modules/menus/wofi
    ./../../../home/modules/menus/bemenu
    # ai: opencode
    ./../../../home/modules/ai
    # network: openvpn, gazelle
    ./../../../home/modules/openvpn
    ./../../../home/modules/tui/gazelle
    # home-manager user
    ./../../../home/users/nix
  ];
  features.vpn = true;
  # features.bluetooth = true;

  hostSpec = {
    username = "juan-albarran";
    fullname = "Juan Albarran";
    email = "work/email";
    hostname = "playa-el-yaque";
    sshKeyName = "playa-el-yaque";
    terminal = "foot";
    terminalAppId = "foot";
    menu = "wofi";
    isNixOS = false;
    # terminal = "ghostty";
    # terminalAppId = "com.mitchellh.ghostty";
    # menu = "wofi --conf $HOME/.config/wofi/projects-menu.conf --prompt 'Projects:'";
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
