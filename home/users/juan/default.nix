# home/users/juan/default.nix
{...}: {
  imports = [
    ./packages.nix
    ./programs.nix
    ./../../modules/ghostty
    ./../../modules/hyprland
    ./../../modules/waybar
    ./../../modules/kanshi
    ./../../modules/tmux
    ./../../modules/starship
    ./../../modules/fastfetch
    ./../../modules/hyprlock
    ./../../modules/wallpapers
  ];

  home = {
    username = "juan";
    homeDirectory = "/home/juan";
    stateVersion = "25.05";
  };
  # Ensures the Home Manager-built Hyprland session is used by the Display Manager
  # and sources the HM-configured environment variables and services.
  xsession.enable = true;

  # Also ensure your hyprland module (./../../modules/hyprland)
  # explicitly configures the Home Manager-specific settings:
  # programs.hyprland.enable = true; # (if you want Home Manager to manage the configuration file)
}
