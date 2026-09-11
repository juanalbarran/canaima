# ./modules/meta/specs.nix
{lib, ...}: {
  options.specs = {
    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "26.05";
      description = "State version for both nixos and home-manager";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "juan";
    };
    fullname = lib.mkOption {
      type = lib.types.str;
      default = "Juan Jesus Albarran Rodriguez";
    };
  };
}
