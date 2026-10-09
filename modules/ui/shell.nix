# ./modules/ui/shell.nix
{inputs, ...}: {
  flake.modules.homeManager.shell = {config, ...}: let
    path = "${config.programs.sarisarinama.package}/share/sarisarinama";
  in {
    imports = [inputs.sarisarinama.modules.homeManager.sarisarinama];
    programs.sarisarinama.enable = true;
    ui.startup = ["env SARISARINAMA_PATH=${path} quickshell -p ${path}"];
    ui.binds.menu = {
      command = "quickshell -p ${path} ipc call shell toggle menu '{}'";
      bind.key = "d";
    };
  };
}
