# home/modules/ghostty/default.nix
{ pkgs, ... }:
{
  home.file = {
    ".config/ghostty/config".source = ./config;
    ".config/ghostty/keybinds".source = ./keybinds.conf;
    ".config/ghostty/shaders/cursor-smear.glsl".source = ./cursor-smear.glsl;
  };
}
