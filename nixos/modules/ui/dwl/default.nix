# nixos/modules/ui/dwl/default.nix
{pkgs, ...}: {
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
  services = { 
    displayManager = { 
      ly.enable = true;
      sessionPackages = [
        (pkgs.writeTextDir "share/wayland-sessions/dwl.desktop" ''
          [Desktop Entry]
          Name=dwl
          Comment=Dynamic window manager for Wayland
          Exec=dwl
          Type=Application
        '')
      ];
    };
  };
  programs.xwayland.enable = true;
}
