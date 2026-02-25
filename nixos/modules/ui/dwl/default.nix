# nixos/modules/ui/dwl/default.nix
{pkgs, ...}: {
  services.displayManager.ly.enable = true;
  environment.systemPackages = with pkgs; [
    (dwl.overrideAttrs (oldAttrs: {
      src = ./config;
      patches = (oldAttrs.patches or []) ++ [
      (pkgs.fetchpatch {
        name = "dwl-movestack";
        url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/movestack/movestack-0.7.patch";
          hash = pkgs.lib.fakeHash;
       })
      (pkgs.fetchpatch {
        name = "dwl-warpcursor";
        url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/warpcursor/warpcursor-0.7.patch";
          hash = pkgs.lib.fakeHash;
       })
      ];
      postPatch = ''
        cp ${./config/config.h} config.h
      '';
    }))
    wl-clipboard
    wlr-randr
  ];
  programs.xwayland.enable = true;
}
