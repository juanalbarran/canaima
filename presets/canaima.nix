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
      hyprland
      ui
      login
      shell
      gaming
    ];
    # Both WMs are listed in tuigreet (F3); this one is picked until it
    # remembers another
    ui.session.command = "sway";
    home-manager.users.juan.imports = [home.canaima];
  };
  flake.modules.homeManager.canaima = {
    imports = with home; [
      core
      juan
      hostspec
      sway
      hyprland
      ui
      shell
      ai
      workspace
      browsers
      media
      gaming
    ];
  };
}
