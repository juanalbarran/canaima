# configurations/labrador.nix
{
  imports = [
    # fonts, localization, networking, experimental-features
    ./../../modules/common
    # window manager
    ./../../modules/ui/dwm
    # menu
    ./../../modules/ui/dmenu
    # terminal
    ./../../modules/terminals/st
    # home-manager configuration
    ./home-configuration/playa-caribe
    # users
    ./../nixos/users/suckless.nix
  ];

  system.stateVersion = "25.11";
}
