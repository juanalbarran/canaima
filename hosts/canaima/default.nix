# hosts/canaima/default.nix
{
  imports = [
    ./services.nix
    ./../../configuration/budapest.nix
    ./hardware/hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  home-manager.users.juan = import ./../../configuration/home-configuration/playa-el-agua;

  system.stateVersion = "25.11";
}
