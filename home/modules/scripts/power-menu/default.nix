# home/modules/scripts/power-menu/default.nix
{
  pkgs,
  config,
  ...
}: let
  menu = config.hostSpec.menu;

  # Base scripts
  power-menu-base = pkgs.writeShellScriptBin "power-menu-base" (builtins.readFile ./power-menu.sh);

  # Power menu wrapper
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    elif [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
      source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    fi

    export BEMENU_BACKEND=wayland
    exec ${power-menu-base}/bin/power-menu-base ${menu}
  '';
in {
  home.packages = [
    power-menu
  ];
}
