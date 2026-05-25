# home/modules/scripts/keybinds/default.nix
{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.keybinds) runOrRaiseApps screenshots actions;
  menu = config.hostSpec.menu;

  displayKey = bindStr: let
    parts = lib.splitString "+" bindStr;
    fmt = p:
      if p == "$mod"
      then "Super"
      else if builtins.stringLength p == 1
      then lib.toUpper p
      else p;
  in
    lib.concatStringsSep " + " (map fmt parts);

  pad = width: str: let
    n = width - builtins.stringLength str;
  in
    str
    + builtins.concatStringsSep "" (builtins.genList (_: " ") (
      if n > 0
      then n
      else 0
    ));

  # Layout constants — window width derives from these
  keyCol = 28; # visual cols for the key column
  nameCol = 22; # visual cols for the name column
  # 2 spaces indent + keyCol + nameCol = content width
  contentCols = keyCol + nameCol + 2;
  # Add margin for font/CSD rounding
  windowCols = contentCols + 6;
  # foot consumes ~2 rows internally; +3 keeps the title row visible
  heightPad = 3;

  row = key: name: "  ${pad keyCol key}${pad nameCol name}";

  # Centered "--- Title ---" header (ASCII hyphens, always visible)
  titleRow = title: let
    decorated = "--- ${title} ---";
    tLen = builtins.stringLength decorated;
    lPad = (contentCols - tLen) / 2;
    spc = n: builtins.concatStringsSep "" (builtins.genList (_: " ") n);
  in "${spc lPad}--- ${title} ---";

  # Full-width section divider (2-space indent, hyphens to content edge)
  divider = "  " + builtins.concatStringsSep "" (builtins.genList (_: "-") (contentCols - 2));

  # lines = number of lines in a \n-joined string (no trailing newline)
  lineCount = s: builtins.length (lib.splitString "\n" s);

  applicationsContent = lib.concatStringsSep "\n" (
    [(titleRow "Applications") ""]
    ++ map (app: row (displayKey app.keybind) app.name) (lib.attrValues runOrRaiseApps)
  );

  screenshotsContent = lib.concatStringsSep "\n" [
    (titleRow "Screenshots")
    ""
    (row (displayKey screenshots.full.keybind) screenshots.full.name)
    (row (displayKey screenshots.area.keybind) screenshots.area.name)
    (row (displayKey screenshots.clip.keybind) screenshots.clip.name)
    divider
    (row (displayKey actions.wallpaper.keybind) actions.wallpaper.name)
  ];

  actionsContent = lib.concatStringsSep "\n" [
    (titleRow "Actions")
    ""
    (row (displayKey actions.kill.keybind) actions.kill.name)
    (row (displayKey actions.launcher.keybind) actions.launcher.name)
    (row (displayKey actions.bookmarks.keybind) actions.bookmarks.name)
    (row (displayKey actions.projects.keybind) actions.projects.name)
    (row (displayKey actions.projectsCtwo.keybind) actions.projectsCtwo.name)
    divider
    (row (displayKey actions.lock.keybind) actions.lock.name)
    (row (displayKey actions.theme.keybind) actions.theme.name)
    (row (displayKey actions.reload.keybind) actions.reload.name)
    (row (displayKey actions.exit.keybind) actions.exit.name)
    divider
    (row (displayKey actions.keybinds.keybind) actions.keybinds.name)
    (row (displayKey actions.network.keybind) actions.network.name)
  ];

  appHeight = toString (lineCount applicationsContent + heightPad);
  ssHeight = toString (lineCount screenshotsContent + heightPad);
  actHeight = toString (lineCount actionsContent + heightPad);

  # ── Neovim sections ──
  nvGeneralContent = lib.concatStringsSep "\n" [
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

  nvSurroundContent = lib.concatStringsSep "\n" [
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

  nvLspCommonContent = lib.concatStringsSep "\n" [
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

  nvLspJavaContent = lib.concatStringsSep "\n" [
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

  nvLspRustContent = lib.concatStringsSep "\n" [
    (titleRow "LSP: Rust")
    ""
    (row "<leader>rb" "Cargo build")
    (row "<leader>rr" "Cargo run")
    (row "<leader>rt" "Cargo test")
    (row "<leader>rc" "Cargo clean")
  ];

  nvLspCsharpContent = lib.concatStringsSep "\n" [
    (titleRow "LSP: C#")
    ""
    "  No C#-specific keybinds."
    "  Uses LSP Common keybinds."
    divider
    "  Formatter: CSharpier"
    "  Debugger:  netcoredbg"
  ];

  nvLspWebContent = lib.concatStringsSep "\n" [
    (titleRow "LSP: Web")
    ""
    (row "<leader>io" "Organize imports")
    (row "<leader>is" "Sort imports")
    (row "<leader>ir" "Remove unused imports")
    (row "<leader>ia" "Add missing imports")
  ];

  nvDebugContent = lib.concatStringsSep "\n" [
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

  nvGenHeight = toString (lineCount nvGeneralContent + heightPad);
  nvSurroundHeight = toString (lineCount nvSurroundContent + heightPad);
  nvLspCommonHeight = toString (lineCount nvLspCommonContent + heightPad);
  nvLspJavaHeight = toString (lineCount nvLspJavaContent + heightPad);
  nvLspRustHeight = toString (lineCount nvLspRustContent + heightPad);
  nvLspCsharpHeight = toString (lineCount nvLspCsharpContent + heightPad);
  nvLspWebHeight = toString (lineCount nvLspWebContent + heightPad);
  nvDebugHeight = toString (lineCount nvDebugContent + heightPad);

  keybinds-base = pkgs.writeShellScriptBin "keybinds-base" ''
    export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

    if [ "$#" -lt 1 ]; then
      echo "Usage: $0 <menu_command> [menu_args...]"
      exit 1
    fi

    MENU_CMD=("$@")
    MENU_PROG="$1"

    CONFIG="$HOME/.config/wofi/config-menu.conf"
    STYLE="$HOME/.config/wofi/style.css"

    get_height() {
        local line_count
        line_count=$(echo -e "$1" | wc -l)
        echo $(( (line_count * 32) + 28 ))
    }

    run_menu() {
        local input_data="$1"
        local height_val="$2"
        local prompt="$3"
        if [[ "$MENU_PROG" == *"wofi"* ]]; then
            echo -e "$input_data" | "''${MENU_CMD[@]}" --conf "$CONFIG" --style "$STYLE" \
                --height "$height_val" --cache-file /dev/null --dmenu --prompt "$prompt"
        else
            echo -e "$input_data" | "''${MENU_CMD[@]}" --prompt "$prompt"
        fi
    }

    show_in_foot() {
        local title="$1"
        local content="$2"
        local height="$3"
        KEYBINDS_DISPLAY="$content" foot --title "$title" -a keybinds \
            --window-size-chars "${toString windowCols}x$height" \
            bash -c 'printf "\033[?25l\033[2J\033[H%s\n" "$KEYBINDS_DISPLAY"; read -n 1 -s -r'
    }

    APPLICATIONS_CONTENT=${lib.escapeShellArg applicationsContent}
    SCREENSHOTS_CONTENT=${lib.escapeShellArg screenshotsContent}
    ACTIONS_CONTENT=${lib.escapeShellArg actionsContent}
    NV_GENERAL_CONTENT=${lib.escapeShellArg nvGeneralContent}
    NV_SURROUND_CONTENT=${lib.escapeShellArg nvSurroundContent}
    NV_LSP_COMMON_CONTENT=${lib.escapeShellArg nvLspCommonContent}
    NV_LSP_JAVA_CONTENT=${lib.escapeShellArg nvLspJavaContent}
    NV_LSP_RUST_CONTENT=${lib.escapeShellArg nvLspRustContent}
    NV_LSP_CSHARP_CONTENT=${lib.escapeShellArg nvLspCsharpContent}
    NV_LSP_WEB_CONTENT=${lib.escapeShellArg nvLspWebContent}
    NV_DEBUG_CONTENT=${lib.escapeShellArg nvDebugContent}

    applications_page() { show_in_foot "Applications" "$APPLICATIONS_CONTENT" ${appHeight}; }
    screenshots_page()  { show_in_foot "Screenshots"  "$SCREENSHOTS_CONTENT"  ${ssHeight}; }
    actions_page()      { show_in_foot "Actions"       "$ACTIONS_CONTENT"      ${actHeight}; }

    nv_general_page()    { show_in_foot "General"     "$NV_GENERAL_CONTENT"    ${nvGenHeight}; }
    nv_surround_page()   { show_in_foot "Surround"    "$NV_SURROUND_CONTENT"   ${nvSurroundHeight}; }
    nv_lsp_common_page() { show_in_foot "LSP: Common" "$NV_LSP_COMMON_CONTENT" ${nvLspCommonHeight}; }
    nv_lsp_java_page()   { show_in_foot "LSP: Java"   "$NV_LSP_JAVA_CONTENT"   ${nvLspJavaHeight}; }
    nv_lsp_rust_page()   { show_in_foot "LSP: Rust"   "$NV_LSP_RUST_CONTENT"   ${nvLspRustHeight}; }
    nv_lsp_csharp_page() { show_in_foot "LSP: C#"     "$NV_LSP_CSHARP_CONTENT" ${nvLspCsharpHeight}; }
    nv_lsp_web_page()    { show_in_foot "LSP: Web"    "$NV_LSP_WEB_CONTENT"    ${nvLspWebHeight}; }
    nv_debug_page()      { show_in_foot "Debugger"    "$NV_DEBUG_CONTENT"      ${nvDebugHeight}; }

    system_menu() {
        local opts="  Applications\n  Screenshots\n  Actions"
        local selected
        selected=$(run_menu "$opts" "$(get_height "$opts")" "System")
        case "$selected" in
            *"Applications") applications_page ;;
            *"Screenshots")  screenshots_page ;;
            *"Actions")      actions_page ;;
        esac
    }

    neovim_lsp_menu() {
        local opts="  Common\n  Java\n  Rust\n  C#\n  Web"
        local selected
        selected=$(run_menu "$opts" "$(get_height "$opts")" "LSP")
        case "$selected" in
            *"Common") nv_lsp_common_page ;;
            *"Java")   nv_lsp_java_page ;;
            *"Rust")   nv_lsp_rust_page ;;
            *"C#")     nv_lsp_csharp_page ;;
            *"Web")    nv_lsp_web_page ;;
        esac
    }

    neovim_menu() {
        local opts="  General\n  Surround\n  LSP\n  Debugger"
        local selected
        selected=$(run_menu "$opts" "$(get_height "$opts")" "Neovim")
        case "$selected" in
            *"General")  nv_general_page ;;
            *"Surround") nv_surround_page ;;
            *"LSP")      neovim_lsp_menu ;;
            *"Debugger") nv_debug_page ;;
        esac
    }

    OPTS="  System\n  Neovim"
    SELECTED=$(run_menu "$OPTS" "$(get_height "$OPTS")" "Keybinds")
    case "$SELECTED" in
        *"System") system_menu ;;
        *"Neovim") neovim_menu ;;
    esac
  '';

  keybinds = pkgs.writeShellScriptBin "keybinds" ''
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    elif [ -f "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]; then
      source "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    fi
    export BEMENU_BACKEND=wayland
    exec ${keybinds-base}/bin/keybinds-base ${menu}
  '';
in {
  home.packages = [keybinds];
}
