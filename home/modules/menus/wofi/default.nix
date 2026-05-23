# home/modules/ui/wofi/default.nix
{config, ...}: {
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      insensitive = true;
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
    };
  };
  xdg.configFile = {
    "wofi/config-menu.conf".source = ./config-menu.conf;
    "wofi/bookmarks-menu.conf".source = ./bookmarks-menu.conf;
    "wofi/prebookmarks-menu.conf".source = ./prebookmarks-menu.conf;
    "wofi/projects-menu.conf".source = ./projects-menu.conf;
    "wofi/style.css".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.cacheHome}/style/wofi.css";
  };
}
