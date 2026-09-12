# ./modules/meta/home-manager.nix
{inputs, ...}: {
  flake.modules.nixos.core = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
      };
      sharedModules = [{hostspec = lib.mkDefault config.hostspec;}];
    };
  };
}
