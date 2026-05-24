# home/modules/tui/gazelle/default.nix
{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.gazelle.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."gazelle/theme.toml" = {
    force = true;
    text = ''
      # Gazelle Theme Configuration — managed by Home Manager (dark base16)
      [colors.primary]
      foreground = "#ffffff"
      background = "#131314"

      [colors.normal]
      black   = "#131314"
      red     = "#ea6962"
      green   = "#a9b665"
      yellow  = "#d8a657"
      blue    = "#7aa2f7"
      magenta = "#d3869b"
      cyan    = "#89b482"
      white   = "#ffffff"

      [colors.bright]
      black   = "#665c54"
      red     = "#ea6962"
      green   = "#a9b665"
      yellow  = "#d8a657"
      blue    = "#7aa2f7"
      magenta = "#d3869b"
      cyan    = "#89b482"
      white   = "#fbf1c7"
    '';
  };
}
