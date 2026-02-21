# configurations/caracas.nix
{
  imports = [
    # fonts, localization, networking, experimental-features
    ./../../modules/common
    # window manager
    ./../../modules/ui/dwm
    # laptops
    ./../nixos/modules/common/laptop.nix
    # home-manager configuration
    ./home-configuration/playa-caribe
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
