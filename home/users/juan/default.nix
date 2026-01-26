# home/users/juan/default.nix
{...}: {
  imports = [
    ./packages.nix
    ./programs.nix
    ./../../modules/kanshi
    ./../../modules/browsers
    ./../../modules/terminals
    # UI modules
    ./../../modules/ui/hyprlock
    ./../../modules/ui/wallpapers
    ./../../modules/ui/waybar
    ./../../modules/ui/hyprland
    ./../../modules/ui/wofi
    ./../../modules/ui/themes
    ./../../modules/ai
  ];

  host.isNixOS = true;

  home = {
    username = "juan";
    homeDirectory = "/home/juan";
    stateVersion = "25.11";
  };
  # Ensures the Home Manager-built Hyprland session is used by the Display Manager
  # and sources the HM-configured environment variables and services.
  xsession.enable = true;

  # Also ensure your hyprland module (./../../modules/hyprland)
  # explicitly configures the Home Manager-specific settings:
  # programs.hyprland.enable = true; # (if you want Home Manager to manage the configuration file)
}
