# ./modules/work/projects.nix
{
  flake.modules.homeManager.work = {config, ...}: let
    path = "${config.programs.sarisarinama.package}/share/sarisarinama";
  in {
    # The shell's projects menu (needs the shell module), rooted at the CTWO
    # work tree instead of ~/dev
    ui.binds.projectsCtwo = {
      command = "env SARISARINAMA_PATH=${path} sarisarinama-projects-menu ~/nix/ctwo/ctwo-product";
      bind = {
        mods = ["mod" "shift"];
        key = "p";
      };
    };
  };
}
