# home/modules/scripts/keybinds/neovim/lsp.nix
{ lib, row, titleRow, divider, lineCount, heightPad }:
let
  mk = items: let content = lib.concatStringsSep "\n" items;
    in { inherit content; height = toString (lineCount content + heightPad); };

  common = mk [
    (titleRow "LSP: Common")
    ""
    (row "gd" "Go to definition")
    (row "gD" "Go to declaration")
    (row "gtd" "Go to type definition")
    (row "gr" "Go to references")
    (row "gi" "Go to implementations")
    (row "gs" "Document symbols")
    divider
    (row "K" "Hover docs")
    (row "<leader>ca" "Code actions")
    (row "<leader>rn" "Rename")
    (row "<leader>sh" "Signature help")
    (row "Ctrl+K" "Signature help (ins)")
    divider
    (row "<leader>th" "Toggle inlay hints")
  ];

  java = mk [
    (titleRow "LSP: Java")
    ""
    (row "<leader>jc" "Create Java Class")
    (row "<leader>ji" "Create Java Interface")
    (row "<leader>je" "Create Java Enum")
    (row "<leader>jr" "Create Java Record")
    (row "<leader>ja" "Create Java Abstract")
    divider
    (row "<leader>io" "Organize imports")
    (row "<leader>jv" "Extract var (visual)")
    (row "<leader>jm" "Extract method (vis)")
    divider
    (row "<leader>jgs" "Gen Setters/Getters")
    (row "<leader>jgc" "Gen Constructor")
    (row "<leader>jgt" "Gen toString")
    (row "<leader>jgh" "Gen hashCode/Equals")
    divider
    (row "<leader>jtc" "Test class")
    (row "<leader>jtm" "Test nearest method")
    divider
    (row "<leader>jmt" "Maven test")
    (row "<leader>jmc" "Maven clean")
    (row "<leader>jmb" "Maven build")
    (row "<leader>jmp" "Maven package")
  ];

  rust = mk [
    (titleRow "LSP: Rust")
    ""
    (row "<leader>rb" "Cargo build")
    (row "<leader>rr" "Cargo run")
    (row "<leader>rt" "Cargo test")
    (row "<leader>rc" "Cargo clean")
  ];

  csharp = mk [
    (titleRow "LSP: C#")
    ""
    "  No C#-specific keybinds."
    "  Uses LSP Common keybinds."
    divider
    "  Formatter: CSharpier"
    "  Debugger:  netcoredbg"
  ];

  web = mk [
    (titleRow "LSP: Web")
    ""
    (row "<leader>io" "Organize imports")
    (row "<leader>is" "Sort imports")
    (row "<leader>ir" "Remove unused imports")
    (row "<leader>ia" "Add missing imports")
  ];
in { inherit common java rust csharp web; }
