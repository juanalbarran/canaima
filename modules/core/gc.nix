# ./modules/core/gc.nix
{
  flake.modules.nixos.core = {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    nix.settings.auto-optimise-store = true;
  };

  flake.modules.homeManager.core = {
    pkgs,
    lib,
    ...
  }: {
    nix = {
      package = lib.mkDefault pkgs.nix;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
