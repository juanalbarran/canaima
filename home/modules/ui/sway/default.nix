# home/modules/sway/default.nix
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./foot.nix
  ];
  wayland.windowManager.sway = {
    # Set the package null instead of pkgs.sway, to use the sway installed by apt
    # in the Ubuntu machine
    package = null;
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
    "sway/lock_config".source = ./swaylock.conf;
    "sway/rules.conf".source = ./rules.conf;
  };
  home = {
    packages = with pkgs; [
      grim
      slurp
      wtype
    ];
    activation.createScreenshotsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/Pictures/screenshots
    '';
  };
}
