# hosts/configurations/suckless/default.nix
{pkgs, ...}: {
  imports = [
    ./../../users/suckless.nix
    ./../../hardware/asus/hardware-configuration.nix
    ./../../modules/common # fonts, boot, localization, networking
    ./../../modules/ui/dwm
    ./../../modules/ui/dmenu
    ./../../modules/terminals/st
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # Enable ZRAM to handle the ram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Will not wait to be connected to a network to finish boot
  systemd.services.NetworkManager-wait-online.enable = false;

  system.stateVersion = "25.11";
}
