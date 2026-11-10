# ./modules/work/projects.nix
{
  flake.modules.homeManager.work = {
    config,
    lib,
    ...
  }: let
    path = "${config.programs.sarisarinama.package}/share/sarisarinama";
    root = config.hostspec.workProjectsRoot;
  in {
    # The shell's projects menu (needs the shell module), rooted at the host's
    # work tree instead of ~/dev
    ui.binds.projectsCtwo = lib.mkIf (root != null) {
      command = "env SARISARINAMA_PATH=${path} sarisarinama-projects-menu ${root}";
      bind = {
        mods = ["mod" "shift"];
        key = "p";
      };
    };
  };
}
