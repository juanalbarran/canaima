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
    # Kills the running shell first, so a WM reload restarts it. Matches the
    # command line: the process name is the wrapper's .quickshell-wrapped,
    # and any store path, so a shell from before a rebuild is killed too
    start = pkgs.writeShellScript "sarisarinama-start" ''
      ${lib.getExe' pkgs.procps "pkill"} -f '^quickshell -p .*/share/sarisarinama$'
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
