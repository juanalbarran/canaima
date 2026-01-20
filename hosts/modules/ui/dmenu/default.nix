# home/modules/ui/dmenu/default.nix
{pkgs, ...}: let
  systemMenu = pkgs.writeShellScriptBin "system-menu" (builtins.readFile ./scripts/system-menu.sh);
  powerMenu = pkgs.writeShellScriptBin "power-menu" (builtins.readFile ./scripts/power-menu.sh);
  projects = pkgs.writeShellScriptBin "projects" (builtins.readFile ./scripts/projects.sh);
in {
  environment.systemPackages = with pkgs; [
    (dmenu.overrideAttrs (_: {
      src = ./config;
      patches = [
        # Center patch (-c)
        (pkgs.fetchpatch {
          url = "https://tools.suckless.org/dmenu/patches/center/dmenu-center-5.2.diff";
          sha256 = "sha256-g7ow7GVUsisR2kQ4dANRx/pJGU8fiG4fR08ZkbUFD5o=";
        })
        # Border patch
        # (pkgs.fetchpatch {
        #   url = "https://tools.suckless.org/dmenu/patches/border/dmenu-border-5.2.diff";
        #   sha256 = "sha256-pf9UM3cEVfYr99HuQeeakYbFNSAJmCPS+uqSI6Anf/I=";
        # })
        # Line Height patch (-h)
        (pkgs.fetchpatch {
          url = "https://tools.suckless.org/dmenu/patches/line-height/dmenu-lineheight-5.2.diff";
          sha256 = "sha256-QdY2T/hvFuQb4NAK7yfBgBrz7Ii7O7QmUv0BvVOdf00=";
        })
      ];
      postPatch = ''
        cp ${./config/config.h} config.h
      '';
    }))
    systemMenu
    powerMenu
    projects
  ];
}
