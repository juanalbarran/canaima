# home/modules/terminals/default.nix
{
  imports = [
    ./fastfetch
    ./ghostty
    ./keybinds
    ./starship
    ./tmux
  ];
}
