# ./modules/core/state-version.nix
{
  flake.modules.nixos.core = {config, ...}: {
    system.stateVersion = config.hostspec.stateVersion;
  };
}
