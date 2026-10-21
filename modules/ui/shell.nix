# ./modules/ui/shell.nix
{
  inputs,
  lib,
  ...
}: {
  # The lock's PAM service, which only NixOS can write to /etc/pam.d
  flake.modules.nixos.shell = {
    imports = [inputs.sarisarinama.modules.nixos.sarisarinama];
  };

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
      style = lib.genAttrs ["menu" "network" "monitor" "vpn" "keybinds" "battery" "notifications"] (_: {
        font.size = config.hostspec.panelFontSize;
      });
      theme.rotateWallpapers = 4; # minutes
      # Only the keybind locks, never idle (#72)
      lock.idle = 0;
      # The shell is the notification daemon; dunst must not hold the bus name
      notifications.enable = true;
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
      nextWallpaper = {
        command = "quickshell -p ${path} ipc call wallpaper next";
        bind = {
          mods = ["mod" "shift"];
          key = "w";
        };
      };
      lock = {
        command = "quickshell -p ${path} ipc call lock lock";
        bind = {
          mods = ["mod" "ctrl"];
          key = "q";
        };
      };
    };
  };
}
