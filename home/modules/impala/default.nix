# home/modules/impala/default.nix
{pkgs, ...}: {
  home.packages = [pkgs.impala];
}
