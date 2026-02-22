# configurations/caracas.nix
{
  imports = [
    # fonts, localization, networking, experimental-features
    ./../nixos/modules/common
    # window manager
    ./../nixos/modules/ui/dwm
    # laptops
    ./../nixos/modules/common/laptop.nix
    # users
    ./../nixos/users/juan.nix
  ];
  services = {
    displayManager.ly.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  system.stateVersion = "25.11";
}
