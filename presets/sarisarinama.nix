# ./presets/sarisarinama.nix
{
  config,
  inputs,
  ...
}: let
  home = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.sarisarinama = {
    imports = [
      home.core
      home.juan-albarran
      home.hostspec
      home.sway
      home.ui
    ];
  };
  flake.homeConfigurations.sarisarinama = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.homeManager.sarisarinama
      {
        hostspec = {
          hostname = "sarisarinama";
          isNixOS = false;
        };
      }
    ];
  };
}
