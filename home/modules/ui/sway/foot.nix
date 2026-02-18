# home/modules/ui/sway/foot.nix
{
  # Foot is needed for the floating windows
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:size=12";
        dpi-aware = "yes";
        pad = "10x10 center";
      };
    };
  };
}
