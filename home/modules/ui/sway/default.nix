# home/modules/sway/default.nix
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./foot.nix
  ];
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
    ];
    activation.createScreenshotsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/Pictures/screenshots
    '';
  };
}
