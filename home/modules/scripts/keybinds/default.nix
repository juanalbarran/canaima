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

  nv = import ./neovim {inherit lib row titleRow divider lineCount heightPad;};

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

    # Wofi layout constants — must match themes/templates/wofi.nix
    FONT_SIZE=16 TEXT_MARGIN=5 WINDOW_PADDING=20 OUTER_PADDING=10 BORDER_WIDTH=2
    get_height() {
        local line_count
        line_count=$(echo -e "$1" | wc -l)
        local row_h=$(( FONT_SIZE + TEXT_MARGIN * 2 ))
        local overhead=$(( (OUTER_PADDING + BORDER_WIDTH) * 2 ))
        echo $(( (( line_count + 1 ) * row_h) + overhead ))
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
    NV_GENERAL_CONTENT=${lib.escapeShellArg nv.general.content}
    NV_SURROUND_CONTENT=${lib.escapeShellArg nv.surround.content}
    NV_LSP_COMMON_CONTENT=${lib.escapeShellArg nv.lsp.common.content}
    NV_LSP_JAVA_CONTENT=${lib.escapeShellArg nv.lsp.java.content}
    NV_LSP_RUST_CONTENT=${lib.escapeShellArg nv.lsp.rust.content}
    NV_LSP_CSHARP_CONTENT=${lib.escapeShellArg nv.lsp.csharp.content}
    NV_LSP_WEB_CONTENT=${lib.escapeShellArg nv.lsp.web.content}
    NV_DEBUG_CONTENT=${lib.escapeShellArg nv.debug.content}

    applications_page() { show_in_foot "Applications" "$APPLICATIONS_CONTENT" ${appHeight}; }
    screenshots_page()  { show_in_foot "Screenshots"  "$SCREENSHOTS_CONTENT"  ${ssHeight}; }
    actions_page()      { show_in_foot "Actions"       "$ACTIONS_CONTENT"      ${actHeight}; }

    nv_general_page()    { show_in_foot "General"     "$NV_GENERAL_CONTENT"    ${nv.general.height}; }
    nv_surround_page()   { show_in_foot "Surround"    "$NV_SURROUND_CONTENT"   ${nv.surround.height}; }
    nv_lsp_common_page() { show_in_foot "LSP: Common" "$NV_LSP_COMMON_CONTENT" ${nv.lsp.common.height}; }
    nv_lsp_java_page()   { show_in_foot "LSP: Java"   "$NV_LSP_JAVA_CONTENT"   ${nv.lsp.java.height}; }
    nv_lsp_rust_page()   { show_in_foot "LSP: Rust"   "$NV_LSP_RUST_CONTENT"   ${nv.lsp.rust.height}; }
    nv_lsp_csharp_page() { show_in_foot "LSP: C#"     "$NV_LSP_CSHARP_CONTENT" ${nv.lsp.csharp.height}; }
    nv_lsp_web_page()    { show_in_foot "LSP: Web"    "$NV_LSP_WEB_CONTENT"    ${nv.lsp.web.height}; }
    nv_debug_page()      { show_in_foot "Debugger"    "$NV_DEBUG_CONTENT"      ${nv.debug.height}; }

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
