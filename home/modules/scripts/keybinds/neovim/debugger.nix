# home/modules/scripts/keybinds/neovim/debugger.nix
{ lib, row, titleRow, divider, lineCount, heightPad }:
let
  content = lib.concatStringsSep "\n" [
    (titleRow "Debugger")
    ""
    (row "<leader>dc" "Continue")
    (row "<leader>do" "Step over")
    (row "<leader>di" "Step into")
    (row "<leader>dx" "Step out")
    divider
    (row "<leader>db" "Toggle breakpoint")
    (row "<leader>dB" "Conditional breakpoint")
    divider
    (row "<leader>du" "Toggle debug UI")
    (row "<leader>dr" "Open REPL")
    (row "<leader>dl" "Run last")
    (row "<leader>dq" "Quit debug")
  ];
in {
  inherit content;
  height = toString (lineCount content + heightPad);
}
