# ./modules/workspace/terminal.nix
{
  flake.modules.homeManager.terminal = {pkgs, ...}: {
    home.packages = [pkgs.nerd-fonts.jetbrains-mono];
    fonts.fontconfig.enable = true;
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=12";
          pad = "10x10 center";
          selection-target = "clipboard";
        };
        scrollback = {
          lines = 10000;
          multiplier = 5.0;
        };
        cursor = {
          style = "block";
          blink = "no";
        };
        url.osc8-underline = "always";
        "regex:hashes".regex = "([a-f0-9]{7,40})";
        bell.urgent = "yes";
        key-bindings = {
          fullscreen = "Control+Return";
          show-urls-copy = "Control+Shift+y";
          regex-copy = "[hashes] Control+Shift+g";
        };
        # Shift+Return as CSI-u, so TUIs like Claude Code can tell it from Return
        text-bindings."\\x1b[13;2u" = "Shift+Return";
      };
    };
  };
}
