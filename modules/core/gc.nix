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
      # Identical files in the store become hard links to one copy. The daemon
      # takes it from ~/.config/nix/nix.conf because the user is trusted
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
  };
}
