# hosts/canaima/default.nix
{
  imports = [
    ./hardware/hardware-configuration.nix
    ./services.nix
    ./../../configuration/budapest.nix
  ];

  home-manager.users.juan = import ./../../configuration/home-configuration/playa-el-agua;

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "25.11";
}
