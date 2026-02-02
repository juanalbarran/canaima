# hosts/sarisarinama/default.nix
{
  imports = [
    ./hardware/hardware-configuration.nix
    ./../../nixos/configurations/suckless
  ];
}
