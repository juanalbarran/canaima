# home/modules/core/gc/default.nix
{
  pkgs,
  lib,
  ...
}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      auto-optimise-store = true;
    };
    package = lib.mkDefault pkgs.nix;
  };
}
