# home/modules/tui/gazelle/default.nix
{
  pkgs,
  gazelle,
  ...
}: {
  home.packages = [
    gazelle.packages.${pkgs.system}.default
  ];
}
