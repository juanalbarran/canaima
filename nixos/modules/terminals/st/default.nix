# nixos/modules/terminals/st/default.nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (st.overrideAttrs (oldAttrs: {
      src = ./config;
      patches = [
        (fetchpatch {
          url = "https://st.suckless.org/patches/clipboard/st-clipboard-20180309-c5bac0.diff";
          sha256 = "sha256-WvjK8nB96jE4Tq+GqD2OQkX0F44g6T+H9WqXyZ8a0A=";
        })
      ];
      postPatch = ''
        cp ${./config/config.h} config.h
      '';
    }))
  ];
}
