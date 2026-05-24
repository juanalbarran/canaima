# configuration/home-configuration/playa-el-yaque/default.nix
{pkgs, ...}: {
  imports = [
    # core: gc, ssh, sops, hostSpec, package, programs
    ./../../../home/modules/core
    # ui: sway, waybar, wallpapers and themes
    ./../../../home/modules/ui/sway
    ./../../../home/modules/ui/hyprland
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
    # work
    ./../../../home/modules/work
  ];
  hostSpec = {
    username = "juan-albarran";
    fullname = "Juan Albarran";
    email = "work/email";
    hostname = "playa-el-yaque";
    sshKeyName = "playa-el-yaque";
    terminal = "foot";
    terminalAppId = "foot";
    # menu = "wofi";
    isNixOS = false;
    # terminal = "ghostty";
    # terminalAppId = "com.mitchellh.ghostty";
    menu = "wofi --conf $HOME/.config/wofi/projects-menu.conf --prompt 'Projects:'";
    windowManager = "sway";
    vpn = true;
    # bluetooth = true;
  };

  targets.genericLinux.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-hyprland
    ];
    config = {
      sway = {default = ["gtk"];};
      hyprland = {default = ["hyprland" "gtk"];};
    };
  };
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (callPackage ./drata-agent.nix {})
  ];
}
