# ./modules/ui/shell.nix
{
  inputs,
  lib,
  ...
}: {
  flake.modules.homeManager.shell = {config, ...}: let
    cfg = config.programs.sarisarinama;
    path = "${cfg.package}/share/sarisarinama";
  in {
    imports = [inputs.sarisarinama.modules.homeManager.sarisarinama];
    programs.sarisarinama = {
      enable = true;
      projects.root = "~/dev";
      style = lib.genAttrs ["menu" "network" "monitor" "vpn"] (_: {
        font.size = config.hostspec.panelFontSize;
      });
    };
    ui.startup = ["env SARISARINAMA_PATH=${path} quickshell -p ${path}"];
    ui.binds = {
      menu = {
        command = "quickshell -p ${path} ipc call shell toggle menu '{}'";
        bind.key = "d";
      };
      projects = {
        command = "env SARISARINAMA_PATH=${path} sarisarinama-projects-menu ${cfg.projects.root}";
        bind.key = "p";
      };
    };
  };
}
