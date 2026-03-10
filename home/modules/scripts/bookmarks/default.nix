# home/modules/scripts/bookmarks/default.nix
{
  pkgs,
  config,
  ...
}: let
  menu = config.hostSpec.menu;

  # Read the bash script below
  bookmarks-base = pkgs.writeShellScriptBin "bookmarks-base" (builtins.readFile ./bookmarks.sh);

  # Wrapper to source variables and execute the base script with the menu command
  bookmarks = pkgs.writeShellScriptBin "bookmarks" ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    elif [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
      source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    fi

    export BEMENU_BACKEND=wayland

    # Pass the menu string from hostSpec as arguments to the base script
    exec ${bookmarks-base}/bin/bookmarks-base ${menu}
  '';
in {
  home.packages = [
    bookmarks
  ];
}
