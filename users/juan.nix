# ./users/juan.nix
{config, ...}: let
  specs = config.specs;
in {
  flake.modules.nixos.juan = {
    users.users.juan = {
      isNormalUser = true;
      description = specs.fullname;
      extraGroups = ["networkmanager" "wheel" "video"];
    };
    nix.settings.trusted-users = ["root" specs.user];
  };
  flake.modules.homeManager.juan = {
    home = {
      username = specs.user;
      homeDirectory = "/home/juan";
      stateVersion = specs.stateVersion;
    };
  };
}
