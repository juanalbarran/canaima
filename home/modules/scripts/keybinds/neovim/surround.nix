# home/modules/scripts/keybinds/neovim/surround.nix
{ lib, row, titleRow, divider, lineCount, heightPad }:
let
  content = lib.concatStringsSep "\n" [
    (titleRow "Surround")
    ""
    (row "ys{motion}{char}" "Add surround")
    (row "yss{char}" "Surround line")
    (row "ds{char}" "Delete surround")
    (row "cs{old}{new}" "Change surround")
    divider
    (row "S{char}" "Surround selection")
    (row "gS{char}" "Surround sel. (block)")
    divider
    (row "Ctrl+G s{char}" "Add surround (insert)")
    divider
    (row ''ysiw"'' ''Surround word in "'')
    (row ''ds"'' ''Delete " surround'')
    (row "cs\"'" "Change \" to '")
    (row "ySS)" "Surround line with ()")
    (row ''ysa)"'' ''Surround () with "'')
  ];
in {
  inherit content;
  height = toString (lineCount content + heightPad);
}
