# hosts/modules/home-manager-fix.nix
{ lib, ... }:
{
  systemd.services.home-manager-juan.serviceConfig.Restart = lib.mkForce "no";
}

