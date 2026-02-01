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

  manual = {
    manpages.enable = false;
    html.enable = false;
    json.enable = false;
  };
}
