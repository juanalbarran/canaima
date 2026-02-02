# hosts/canaima/default.nix
{
  imports = [
    ./hardware/hardware-configuration.nix
    ./../../nixos/configurations/canaima
  ];
}
