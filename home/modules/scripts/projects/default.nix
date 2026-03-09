# home/modules/scripts/projects/projects.nix
{
  pkgs,
  config,
  ...
}: let
  terminal = config.hostSpec.terminal;
  terminalAppId = config.hostSpec.terminalAppId;
  menu = config.hostSpec.menu;
  projects-base = pkgs.writeShellScriptBin "projects-base" (builtins.readFile ./projects.sh);
  projects = pkgs.writeShellScriptBin "projects" ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    elif [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
      source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    fi
    export BEMENU_BACKEND=wayland
    exec ${projects-base}/bin/projects-base ${terminal} ${terminalAppId} ${menu}
  '';
in {
  home.packages = [
    projects
  ];
}
