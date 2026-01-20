# hosts/modules/terminals/st/default.nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (st.overrideAttrs (oldAttrs: {
      src = ./config;
      patches = [];
      postPatch = ''
        cp ${./config/config.h} config.h
      '';
    }))
  ];
}
