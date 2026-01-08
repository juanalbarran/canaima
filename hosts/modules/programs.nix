# hosts/modules/programs.nix
{
  pkgs,
  ghostty,
  ...
}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    ghostty.packages.${system}.default
    wl-clipboard
    wofi
    psmisc # -> the killall command
    kitty
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs = {
    hyprland.enable = true;
    hyprlock.enable = true;
  };
}
