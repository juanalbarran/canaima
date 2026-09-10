# ./presets/canaima.nix
{config, ...}: let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in {
  flake.modules.nixos.canaima = {
    imports = [
      nixos.core
    ];
  };
  flake.modules.homeManager.canaima = {
    imports = [
      home.core
    ];
  };
}
