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
      nixos.sway
      nixos.ui
      nixos.login
    ];
    home-manager.users.juan.imports = [home.canaima];
  };
  flake.modules.homeManager.canaima = {
    imports = [
      home.core
      home.juan
      home.hostspec
      home.sway
      home.ui
      home.editor
      home.multiplexer
      home.shell
    ];
  };
}
