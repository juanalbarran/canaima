# home/user/nix/default.nix
{
  home = {
    username = "juan-albarran";
    homeDirectory = "/home/juan-albarran/";
    stateVersion = "25.11";
    sessionPath = [
      "$HOME/.nix-profile/bin"
    ];
  };
}
