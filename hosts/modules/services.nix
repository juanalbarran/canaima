# hosts/modules/services.nix
{ pkgs, ... }:

{
  # List services that you want to enable:
  services = { 

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Login
    greetd = { 
      enable = true;
      settings.default_session = {
       command = "${pkgs.hyprland}/bin/Hyprland";
       user = "juan";
      };
    };

    # Enable automatic login for the user
    getty.autologinUser = "juan";

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    logind = {
      lidSwitch = "ignore";
      lidSwitchExternalPower = "ignore";
      lidSwitchDocked = "ignore";
    };
  };
}
