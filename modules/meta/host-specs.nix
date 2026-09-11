# ./modules/meta/host-specs.nix
{lib, ...}: {
  flake.modules.nixos.core = {
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
    };
  };
}
