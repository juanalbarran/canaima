# home/modules/scripts/projects/projects.nix
{pkgs, ...}: let
  projects-base = pkgs.writeShellScriptBin "projects-base" (builtins.readFile ./projects.sh);
  projects = pkgs.writeShellScriptBin "projects" ''
    exec ${projects-base}/bin/projects-base -c "wmenu -p 'Projects:'" -t foot
  '';
in {
  home.packages = [
    projects
  ];
}
