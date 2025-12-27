# home/modules/keybinds/default.nix
{pkgs, ...}: let
  show-keybinds = pkgs.writeShellScriptBin "show-keybinds" (builtins.readFile ./show-keybinds.sh);
in {
  home.packages = [
    show-keybinds
  ];
}
