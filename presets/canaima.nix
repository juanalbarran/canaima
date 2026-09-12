# ./presets/canaima.nix
{config, ...}: let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in {
  flake.modules.nixos.canaima = {
    imports = [
      nixos.core
      nixos.juan
      nixos.hostspec
    ];
    home-manager.users.juan.imports = [home.canaima];
  };
  flake.modules.homeManager.canaima = {
    imports = [
      home.core
      home.juan
      home.hostspec
    ];
  };
}
