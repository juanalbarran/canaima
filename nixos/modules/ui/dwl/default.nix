# nixos/modules/ui/dwl/default.nix
{pkgs, ...}: let
  caracasDwl =
    (pkgs.dwl.override {
      configH = ./config.h;
    }).overrideAttrs (oldAttrs: {
      patches =
        (oldAttrs.patches or [])
        ++ [
          (pkgs.fetchpatch {
            name = "dwl-movestack";
            url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/movestack/movestack.patch";
            hash = "sha256-/Ac7oQyZNVPqGiNDn0y94arN0cz98Ie1nKkQIX27bZo=";
          })
          (pkgs.fetchpatch {
            name = "dwl-warpcursor";
            url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/warpcursor/warpcursor.patch";
            hash = "sha256-0AGMq507WmW2QJW02u6eJDuQmGBAiVPbEw79npwqEDU=";
          })
          # (pkgs.fetchpatch {
          #   name = "dwl-foreign-toplevel";
          #   url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/foreign-toplevel-management/foreign-toplevel-management.patch";
          #   hash = "sha256-uOXLJkTTTtb80BnT53yHEOkjJc8QXjJOBKv7eq2RcUw=";
          # })
        ];
    });
in {
  programs.dwl = {
    enable = true;
    package = caracasDwl;
    extraSessionCommands = ''
      unset DISPLAY
      unset XAUTHORITY
      systemctl --user import-environment WAYLAND_DISPLAY >/dev/null 2>&1
      systemctl --user start dwl-session.target
      exec ${caracasDwl}/bin/dwl
    '';
  };

  systemd.services.display-manager.environment = {
    DISPLAY = ":0";
    XAUTHORITY = "/tmp/xauth";
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wlr-randr
    wlrctl
  ];

  services.displayManager.ly.enable = true;

  programs.dconf.enable = true;
  security.polkit.enable = true;
  hardware.graphics.enable = true;
}
