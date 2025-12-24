# home/modules/sway/default.nix
{
  xdg.configFile = {
    "sway/config".source = ./config;
    "sway/variables.conf".source = ./variables.conf;
    "sway/autostart.conf".source = ./autostart.conf;
    "sway/bindings.conf".source = ./bindings.conf;
    "sway/monitors.conf".source = ./monitors.conf;
    "sway/lock_config".source = ./swaylock.conf;
    "sway/rules.conf".source = ./rules.conf;
  };
}
