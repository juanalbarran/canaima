# hosts/sarisarinama/default.nix
{
  imports = [
    ./hardware/hardware-configuration.nix
    ./../../configuration/caracas.nix
  ];
  home-manager.users.juan = import ./../../configuration/home-configuration/playa-caribe;
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
}
