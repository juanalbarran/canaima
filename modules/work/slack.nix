# ./modules/work/slack.nix
{
  flake.modules.homeManager.work = {pkgs, ...}: {
    home.packages = [pkgs.slack];
  };
}
