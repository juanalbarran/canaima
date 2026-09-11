# ./modules/core/state-version.nix
{config, ...}: {
  flake.modules.nixos.core = {
    system.stateVersion = config.specs.stateVersion;
  };
}
