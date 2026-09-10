# ./modules/meta/flake-parts.nix
{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
