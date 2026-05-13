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

  mkProjects = name: projectsPath:
    pkgs.writeShellScriptBin name ''
      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      elif [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
        source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
      fi
      export BEMENU_BACKEND=wayland
      exec ${projects-base}/bin/projects-base "${projectsPath}" ${terminal} ${terminalAppId} ${menu}
    '';

  projects = mkProjects "projects" "$HOME/dev";
  projects-ctwo = mkProjects "projects-ctwo" "$HOME/nix/ctwo/repositories";
in {
  home.packages = [
    projects
    projects-ctwo
  ];
}
