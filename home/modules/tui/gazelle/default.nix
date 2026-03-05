# home/modules/tui/gazelle/default.nix
{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.gazelle.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
