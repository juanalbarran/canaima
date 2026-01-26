# home/modules/ui/swaylock/default.nix
{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # Appearance
      color = "1e1e2e";
      font = "JetBrainsMono Nerd Font";
      font-size = 24;

      # Indicators
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;

      # Effects (Specific to swaylock-effects)
      screenshots = true;
      clock = true;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";

      # Colors
      ring-color = "3b4252";
      key-hl-color = "88c0d0";
      text-color = "eceff4";
      line-color = "00000000"; # invisible line

      # Behavior
      daemonize = true;
      ignore-empty-password = true;
      show-failed-attempts = true;
    };
  };
}
