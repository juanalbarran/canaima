# configurations/budapest.nix
{
  imports = [
    # display manager
    ./../nixos/modules/ui/sway
    # fonts, boot, localization, networking, experimental-features
    ./../nixos/modules/common
    # user
    ./../nixos/users/juan.nix
  ];
  system.stateVersion = "25.11";
}
