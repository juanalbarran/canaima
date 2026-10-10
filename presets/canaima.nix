# ./presets/canaima.nix
{config, ...}: let
  nixos = config.flake.modules.nixos;
  home = config.flake.modules.homeManager;
in {
  flake.modules.nixos.canaima = {
    imports = with nixos; [
      core
      juan
      hostspec
      sway
      ui
      login
    ];
    home-manager.users.juan.imports = [home.canaima];
  };
  flake.modules.homeManager.canaima = {
    imports = with home; [
      core
      juan
      hostspec
      sway
      ui
      shell
      ai
      workspace
      browsers
      media
    ];
  };
}
