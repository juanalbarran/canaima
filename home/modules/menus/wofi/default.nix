# home/modules/ui/wofi/default.nix
{
  pkgs,
  config,
  ...
}: let
  powerMenu = pkgs.writeShellScriptBin "power-menu-wofi" (builtins.readFile ./scripts/power-menu.sh);
  keybinds = pkgs.writeShellScriptBin "keybinds-wofi" (builtins.readFile ./scripts/keybinds.sh);
  bookmarks = pkgs.writeShellScriptBin "bookmarks-wofi" (builtins.readFile ./scripts/bookmarks.sh);
  systemMenu = pkgs.writeShellScriptBin "system-menu-wofi" (builtins.readFile ./scripts/system-menu.sh);
  projects = pkgs.writeShellScriptBin "projects-wofi" (builtins.readFile ./scripts/projects.sh);
in {
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
  home.packages = with pkgs; [
    systemMenu
    powerMenu
    keybinds
    bookmarks
    bluetuith
    projects
  ];
}
