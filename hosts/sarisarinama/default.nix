# hosts/sarisarinama/default.nix
{
  imports = [
    ./hardware/hardware-configuration.nix
    ./../../configuration/caracas.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
}
