# nixos/configurations/suckless/default.nix
{
  imports = [
    ./../../users/suckless.nix
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

  # Will not wait to be connected to a network to finish boot
  systemd.services.NetworkManager-wait-online.enable = false;

  system.stateVersion = "25.11";
}
