# hosts/configurations/suckless/default.nix
{pkgs, ...}: {
  imports = [
    ./../../users/suckless.nix
    ./../../hardware/asus/hardware-asus-laura.nix
    ./../../modules/common # fonts, localization, networking
    ./../../modules/ui/dwm
    ./../../modules/ui/dmenu
    ./../../modules/terminals/st
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable ZRAM to handle the ram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;


  # Will not wait to be connected to a network to finish boot
  systemd.services.NetworkManager-wait-online.enable = false;

  system.stateVersion = "25.11";
}
