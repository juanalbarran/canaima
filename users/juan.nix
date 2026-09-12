# ./users/juan.nix
{
  flake.modules.nixos.juan = {
    users.users.juan = {
      isNormalUser = true;
      description = "Juan Jesus Albarran Rodriguez";
      extraGroups = ["networkmanager" "wheel" "video"];
    };
    nix.settings.trusted-users = ["root" "juan"];
  };
  flake.modules.homeManager.juan = {config, ...}: {
    home = {
      username = "juan";
      homeDirectory = "/home/juan";
      stateVersion = config.hostspec.stateVersion;
    };
  };
}
