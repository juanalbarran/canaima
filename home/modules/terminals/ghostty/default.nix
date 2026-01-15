# home/modules/ghostty/default.nix
{
  ghostty,
  system,
  ...
}: {
  home.file = {
    ".config/ghostty/config".source = ./config;
    ".config/ghostty/keybinds.conf".source = ./keybinds.conf;
    ".config/ghostty/shaders/cursor-smear.glsl".source = ./cursor-smear.glsl;
    ".config/ghostty/window-rules/nmtui.toml".source = ./window-rules/nmtui.toml;
    ".config/ghostty/window-rules/keybinds.toml".source = ./window-rules/keybinds.toml;
    ".config/ghostty/window-rules/pulsemixer.toml".source = ./window-rules/pulsemixer.toml;
  };
  home.packages = [
    ghostty.packages.${system}.default
  ];
}
