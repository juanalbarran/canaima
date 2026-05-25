# home/modules/ui/keybinds/hyprland.nix
vars:
{ lib, ... }:
let
  inherit (vars) hyprMod runOrRaiseApps actions;

  # Converts "$mod+Shift+q" -> "$mod SHIFT, q,"
  toHyprBind = bindStr:
    let
      parts  = lib.splitString "+" bindStr;
      key    = lib.last parts;
      mods   = lib.init parts;
      fmtMod = m: if m == "$mod" then "$mod" else lib.toUpper m;
      modStr = lib.concatStringsSep " " (map fmtMod mods);
    in "${modStr}, ${key},";

  mkHyprBind = { keybind, app, appId, matchBy ? "class", ... }:
    let
      matcher  = if matchBy == "title" then "title" else "class";
      dispatch = "hyprctl clients | grep \"${matcher}: ${appId}\" && hyprctl dispatch focuswindow \"${matcher}:^${appId}$\" || ${app}";
    in "bind = ${toHyprBind keybind} exec, ${dispatch}";

  mkActionBind = { keybind, hypr ? null, cmd ? null, ... }:
    let action = if hypr != null then hypr else "exec, ${cmd}";
    in "bind = ${toHyprBind keybind} ${action}";
in {
  xdg.configFile."hypr/shared-keybinds.conf".text = ''
    $mod = ${hyprMod}

    # Run or raise
    ${lib.concatStringsSep "\n    " (map mkHyprBind (lib.attrValues runOrRaiseApps))}

    # Screenshots
    bind = ,        Print, exec, mkdir -p $ssDir && grim "$ssDir/$(date +'%Y-%m-%d_%H-%M-%S.png')"
    bind = SHIFT,   Print, exec, mkdir -p $ssDir && grim -g "$(slurp)" "$ssDir/$(date +'%Y-%m-%d_%H-%M-%S.png')"
    bind = CONTROL, Print, exec, grim -g "$(slurp)" - | wl-copy

    # Actions
    ${lib.concatStringsSep "\n    " (map mkActionBind (lib.attrValues actions))}
  '';
}
