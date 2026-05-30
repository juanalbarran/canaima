# configurations/caracas.nix
{
  imports = [
    # fonts, localization, networking, experimental-features
    ./../nixos/modules/common
    # window manager
    ./../nixos/modules/ui/dwl
    # laptops
    ./../nixos/modules/common/laptop.nix
    # games
    ./../nixos/modules/game
    # users
    ./../nixos/users/juan.nix
  ];
  system.stateVersion = "25.11";
}
