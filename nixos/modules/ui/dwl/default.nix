# nixos/modules/ui/dwl/default.nix
{pkgs, ...}: {
  programs.dwl = {
    enable = true;
    package =
      (pkgs.dwl.override {
        configH = ./config.h;
      }).overrideAttrs (oldAttrs: {
        # src = ./config;

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
          ];
      });
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wlr-randr
  ];

  services = {
    displayManager = {
      ly.enable = true;
    };
  };

  programs.xwayland.enable = true;
  programs.dconf.enable = true;
  security.polkit.enable = true;
  hardware.graphics.enable = true;
}
