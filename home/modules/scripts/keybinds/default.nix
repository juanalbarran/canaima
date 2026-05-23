# home/modules/scripts/keybinds/default.nix
{pkgs, ...}: let
  keybinds = pkgs.writeShellScriptBin "keybinds" (builtins.readFile ./keybinds.sh);
in {
  home.packages = [keybinds];
}
