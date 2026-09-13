# ./presets/sarisarinama.nix
{config, ...}: let
  home = config.flake.modules.homeManager;
in {
  flake.modules.homeManager.sarisarinama = {
    imports = [
      home.core
      home.juan-albarran
      home.hostspec
    ];
  };
}
