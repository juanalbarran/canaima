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

  # console = {
  #   enable = true;
  #   font = "ter-v16n";
  #   packages = [pkgs.terminus_font];
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
