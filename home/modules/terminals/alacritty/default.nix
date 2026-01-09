# home/modules/terminals/alacritty/default.nix
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        opacity = 0.95;
        title = "Alacritty";
        dynamic_title = true;
      };

      font = {
        size = 12.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
      };

      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
      };
    };
  };
}
