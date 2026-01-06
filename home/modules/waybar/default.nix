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
      height = 28;
    };
    style = lib.concatStrings [
      (builtins.readFile ./style.css)
      (builtins.readFile ./components/clock/clock.css)
      (builtins.readFile ./components/workspaces/workspaces.css)
    ];
  };
}
