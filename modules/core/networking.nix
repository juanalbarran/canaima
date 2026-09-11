# ./modules/core/networking.nix
{
  flake.modules.nixos.core = {config, ...}: {
    networking.hostName = config.hostspec.hostname;
    networking.networkmanager.enable = true;
  };
}
