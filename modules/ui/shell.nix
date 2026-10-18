# ./modules/ui/shell.nix
{
  inputs,
  lib,
  ...
}: {
  flake.modules.homeManager.shell = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.programs.sarisarinama;
    path = "${cfg.package}/share/sarisarinama";
    # Kills the running shell first, so a WM reload restarts it
    start = pkgs.writeShellScript "sarisarinama-start" ''
      ${lib.getExe' pkgs.procps "pkill"} -x quickshell
      SARISARINAMA_PATH=${path} exec quickshell -p ${path}
    '';
  in {
    imports = [inputs.sarisarinama.modules.homeManager.sarisarinama];
    programs.sarisarinama = {
      enable = true;
      projects.root = "~/dev";
      style = lib.genAttrs ["menu" "network" "monitor" "vpn"] (_: {
        font.size = config.hostspec.panelFontSize;
      });
    };
    ui.reload = ["${start}"];
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
