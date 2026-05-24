# home/modules/waybar/default.nix
{
  lib,
  config,
  ...
}: {
  imports = [
    ./components
  ];
  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = false;
      settings.mainBar = {
        layer = "bottom";
        position = "bottom";
        height = 30;
      };
      style = lib.concatStrings (
        [
          "@import url(\"${config.home.homeDirectory}/.cache/style/waybar-colors.css\");\n\n"
          (builtins.readFile ./style.css)
          (builtins.readFile ./components/components.css)
          (builtins.readFile ./components/clock/clock.css)
          (builtins.readFile ./components/workspaces/workspaces.css)
          (builtins.readFile ./components/battery/battery.css)
          (builtins.readFile ./components/network/network.css)
          (builtins.readFile ./components/pulseaudio/pulseaudio.css)
          #(builtins.readFile ./components/memory/memory.css)
          #(builtins.readFile ./components/cpu/cpu.css)
        ]
        ++ (lib.optionals config.hostSpec.bluetooth [
          (builtins.readFile ./components/bluetooth/bluetooth.css)
        ])
        ++ (lib.optionals config.hostSpec.vpn [
          (builtins.readFile ./components/vpn/vpn.css)
        ])
      );
    };
  };
}
