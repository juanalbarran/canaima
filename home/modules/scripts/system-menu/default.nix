# home/modules/scripts/system-menu/default.nix
{
  pkgs,
  config,
  ...
}: let
  menu = config.hostSpec.menu;
  system-menu-base = pkgs.writeShellScriptBin "system-menu-base" (builtins.readFile ./system-menu.sh);

  # System menu wrapper
  system-menu = pkgs.writeShellScriptBin "system-menu" ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    elif [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
      source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    fi

    export BEMENU_BACKEND=wayland
    exec ${system-menu-base}/bin/system-menu-base ${menu}
  '';
in {
  home.packages = [
    system-menu
  ];
}
