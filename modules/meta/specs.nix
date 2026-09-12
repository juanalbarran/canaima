# ./modules/meta/specs.nix
{lib, ...}: let
  hostspec = {
    options.hostspec = {
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "The machine's hostname";
      };
      isDocked = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Laptop used docked with the lid closed";
      };
      stateVersion = lib.mkOption {
        type = lib.types.str;
        default = "26.05";
        description = "State version for both nixos and home-manager";
      };
    };
  };
in {
  flake.modules.nixos.hostspec = hostspec;
  flake.modules.homeManager.hostspec = hostspec;
}
