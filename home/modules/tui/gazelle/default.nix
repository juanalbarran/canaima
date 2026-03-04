# home/modules/tui/gazelle/default.nix
{
  pkgs,
  gazelle,
  ...
}: {
  home.packages = [
    gazelle.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
