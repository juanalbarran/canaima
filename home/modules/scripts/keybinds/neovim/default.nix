# home/modules/scripts/keybinds/neovim/default.nix
{ lib, row, titleRow, divider, lineCount, heightPad }:
let
  helpers = { inherit lib row titleRow divider lineCount heightPad; };
in {
  general  = import ./general.nix  helpers;
  surround = import ./surround.nix helpers;
  lsp      = import ./lsp.nix      helpers;
  debug    = import ./debugger.nix helpers;
}
