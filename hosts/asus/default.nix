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
      {
        hostspec = {
          hostname = "canaima";
          isDocked = true;
        };
      }
    ];
  };
}
