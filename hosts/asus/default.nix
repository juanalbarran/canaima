# ./hosts/asus/default.nix
{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.asus = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      ./_hardware.nix
      config.flake.modules.nixos.canaima
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.users.juan.imports = [config.flake.modules.homeManager.canaima];
      }
      {
        hostspec = {
          hostname = "canaima";
          isDocked = true;
        };
      }
    ];
  };
}
