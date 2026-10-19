# ./modules/media/qbittorrent.nix
{
  flake.modules.homeManager.media = {pkgs, ...}: {
    home.packages = [pkgs.qbittorrent];
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
        "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
      };
    };
  };
}
