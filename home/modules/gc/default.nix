# home/modules/gc/default.nix
{pkgs, ...}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
    };
    package = pkgs.nix;
  };
}
