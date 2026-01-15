# hosts/configurations/suckless/default.nix
{pkgs, ...}: {
  imports = [
    ./../../modules/boot.nix
    ./../../modules/networking.nix
    ./../../modules/localization.nix
    ./../../users/suckless.nix
    ./../../hardware/asus/hardware-configuration.nix
    ./../../modules/common
    ./../../modules/ui/dwm
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  console = {
    enable = true;
    font = "ter-v16n";
    packages = [pkgs.terminus_font];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
