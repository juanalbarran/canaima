# hosts/modules/ui/dwm/default.nix
{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs (overrideAttr: {
          src = ./config;
          postPatch = ''
            cp ${./config/config.h} config.h
          '';
        });
      };
    };
    picom.enable = true;
  };
  environment.systemPackages = with pkgs; [
    xclip
    wmctrl
  ];
}
