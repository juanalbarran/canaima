# hosts/canaima/default.nix
{pkgs, ...}: {
  imports = [
    ./services.nix
    ./../../configuration/pointer.nix
    ./hardware/hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  home-manager.users.juan = import ./../../home/users/juan;

  system.stateVersion = "25.11";
}
