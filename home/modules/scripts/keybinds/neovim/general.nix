# home/modules/scripts/keybinds/neovim/general.nix
{ lib, row, titleRow, divider, lineCount, heightPad }:
let
  content = lib.concatStringsSep "\n" [
    (titleRow "General")
    ""
    (row "-" "Oil file browser")
    (row "<leader>e" "Neo-tree toggle")
    divider
    (row "<leader>vs" "Vertical split")
    (row "<leader>hs" "Horizontal split")
    (row "Ctrl+L" "Window right")
    (row "Ctrl+H" "Window left")
    divider
    (row "za" "Toggle fold")
    (row "zo" "Open fold")
    (row "zc" "Close fold")
    (row "zR" "Open all folds")
    (row "zM" "Close all folds")
    divider
    (row "<leader>ff" "Find files")
    (row "<leader>fb" "Find buffers")
    (row "<leader>fw" "Find word")
    (row "<leader>fg" "Find by grep")
    (row "<leader>fr" "Resume search")
    divider
    (row "<leader>sr" "Search & Replace")
    (row "<leader>bd" "Buffer delete")
    (row "<leader>bda" "Buffer delete all")
    (row "<leader>ac" "Toggle AI")
    (row "Esc" "Clear highlight")
  ];
in {
  inherit content;
  height = toString (lineCount content + heightPad);
}
