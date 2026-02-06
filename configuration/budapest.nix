# configurations/budapest.nix
{
  imports = [
    # display manager
    ./../nixos/modules/ui/sway
    # fonts, boot, localization, networking, experimental-features
    ./../nixos/modules/common
    # home-manager configuration
    ./home-configuration/playa-el-agua
    # user
    ./../nixos/users/juan.nix
  ];
  system.stateVersion = "25.11";
}
