# home/modules/waybar/default.nix
{
  imports = [
    ./components
  ];
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = {
      mainBar = {
        layer = "bottom";
        position = "bottom";
        height = 28;

        modules-right = ["cpu" "memory" "battery" "network"];
      };
    };
    style = builtins.readFile ./style.css;
  };
}
