# home/home.nix
{ ... }:
{
  home-manager.users.juan = import ./home-config.nix;
}
