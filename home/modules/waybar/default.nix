# home/modules/waybar/default.nix
{lib, ...}: {
  imports = [
    ./components
  ];
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings.mainBar = {
      layer = "bottom";
      position = "bottom";
      height = 30;
    };
    style = lib.concatStrings [
      (builtins.readFile ./style.css)
      (builtins.readFile ./components/components.css)
      (builtins.readFile ./components/clock/clock.css)
      (builtins.readFile ./components/workspaces/workspaces.css)
      (builtins.readFile ./components/memory/memory.css)
      (builtins.readFile ./components/battery/battery.css)
      (builtins.readFile ./components/network/network.css)
      (builtins.readFile ./components/bluetooth/bluetooth.css)
    ];
  };
}
