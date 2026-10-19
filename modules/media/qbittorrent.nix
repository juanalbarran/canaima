# ./modules/media/qbittorrent.nix
{
  flake.modules.homeManager.media = {pkgs, ...}: {
    home.packages = [pkgs.qbittorrent];
  };
}
