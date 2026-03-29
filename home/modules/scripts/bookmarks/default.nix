# home/modules/scripts/bookmarks/default.nix
{
  pkgs,
  config,
  ...
}: let
  menu = config.hostSpec.menu;
  isNixOS = config.hostSpec.isNixOS;
  username = config.hostSpec.username;
  envPath = 
    if isNixOS 
    then "/etc/profiles/per-user/${username}/etc/profile.d/hm-session-vars.sh"
    else "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh";

  # Read the bash script below
  bookmarks-base = pkgs.writeShellScriptBin "bookmarks-base" (builtins.readFile ./bookmarks.sh);

  # Wrapper to source variables and execute the base script with the menu command
  bookmarks = pkgs.writeShellScriptBin "bookmarks" ''

    if [ -f "${envPath}" ]; then
      source "${envPath}"
    fi
    
    export BEMENU_BACKEND=wayland

    # Pass the menu string from hostSpec as arguments to the base script
    exec ${bookmarks-base}/bin/bookmarks-base ${menu}
  '';
in {
  home.packages = [
    bookmarks
  ];
  xdg.configFile = {
    "bookmarks/chill.txt".source = ./../../../assets/bookmarks/chill.txt;
    "bookmarks/work.txt".source = ./../../../assets/bookmarks/work.txt;
    "bookmarks/code.txt".source = ./../../../assets/bookmarks/code.txt;
    "bookmarks/dotfiles.txt".source = ./../../../assets/bookmarks/dotfiles.txt;
    "bookmarks/blogs.txt".source = ./../../../assets/bookmarks/blogs.txt;
  };
}
