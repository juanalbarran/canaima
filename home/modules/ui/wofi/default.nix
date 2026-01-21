# home/modules/ui/wofi/default.nix
{pkgs, ...}: let
  powerMenu = pkgs.writeShellScriptBin "power-menu" (builtins.readFile ./scripts/power-menu.sh);
  keybinds = pkgs.writeShellScriptBin "keybinds" (builtins.readFile ./scripts/keybinds.sh);
  bookmarks = pkgs.writeShellScriptBin "bookmarks" (builtins.readFile ./scripts/bookmarks.sh);
  systemMenu = pkgs.writeShellScriptBin "system-menu" (builtins.readFile ./scripts/system-menu.sh);
  projects = pkgs.writeShellScriptBin "projects" (builtins.readFile ./scripts/projects.sh);
in {
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      insensitive = true;
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
    };
    style = builtins.readFile ./style.css;
  };
  xdg.configFile = {
    "wofi/config-menu.conf".source = ./config-menu.conf;
    "wofi/bookmarks-menu.conf".source = ./bookmarks-menu.conf;
    "wofi/prebookmarks-menu.conf".source = ./prebookmarks-menu.conf;
    "wofi/projects-menu.conf".source = ./projects-menu.conf;
    "bookmarks/chill.txt".source = ./../../../assets/bookmarks/chill.txt;
    "bookmarks/work.txt".source = ./../../../assets/bookmarks/work.txt;
    "bookmarks/code.txt".source = ./../../../assets/bookmarks/code.txt;
    "bookmarks/dotfiles.txt".source = ./../../../assets/bookmarks/dotfiles.txt;
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
