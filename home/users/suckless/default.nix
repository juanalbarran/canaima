# home/users/suckless/default.nix
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./../../modules/terminals/fastfetch
    ./../../modules/terminals/starship
    ./../../modules/browsers/qutebrowser
    ./../../modules/terminals/tmux
  ];
  home = {
    username = "juan";
    homeDirectory = "/home/juan";
    stateVersion = "25.11";
  };
  # Ensures the Home Manager-built Hyprland session is used by the Display Manager
  # and sources the HM-configured environment variables and services.
  xsession.enable = true;
}
