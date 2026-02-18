# home/modules/sway/default.nix
{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./special-binds
  ];
  options = {
    host.isNixOS = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set to true if running on NixOS, false for Ubuntu/other";
    };
  };
  config = {
    wayland.windowManager.sway = {
      # Set the package null instead of pkgs.sway, to use the sway installed by apt
      # in the Ubuntu machine
      package =
        if config.host.isNixOS
        then pkgs.sway
        else null;
      checkConfig = true;
      config = {
        extraConfig = builtins.readFile ./config;
      };
    };
    xdg.configFile = {
      "sway/config".source = ./config;
      "sway/variables.conf".source = ./variables.conf;
      "sway/autostart.conf".source = ./autostart.conf;
      "sway/bindings.conf".source = ./bindings.conf;
      "sway/monitors.conf".source = ./monitors.conf;
      "sway/rules.conf".source = ./rules.conf;
    };
    home = {
      packages = with pkgs; [
        grim
        slurp
        wtype
        wev
      ];
      activation.createScreenshotsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p $HOME/Pictures/screenshots
      '';
    };
  };
}
