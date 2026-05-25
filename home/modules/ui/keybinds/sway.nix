# home/modules/ui/keybinds/sway.nix
vars:
{ lib, ... }:
let
  inherit (vars) swayMod path runOrRaiseApps actions;

  mkBind = { keybind, app, appId, extraCriteria ? "", matchBy ? "app_id", ... }:
    let
      criteria = if matchBy == "title"
                 then ''class="${appId}" title="${appId}"''
                 else ''app_id="${appId}"${if extraCriteria != "" then " ${extraCriteria}" else ""}'';
    in "bindsym ${keybind} exec $swaymsg '[${criteria}] focus' || exec ${path}${app}";

  mkActionBind = { keybind, sway ? null, cmd ? null, ... }:
    let action = if sway != null then sway else "exec ${path}${cmd}";
    in "bindsym ${keybind} ${action}";
in {
  xdg.configFile."sway/shared-keybinds.conf".text = ''
    set $mod ${swayMod}

    # Run or raise
    ${lib.concatStringsSep "\n    " (map mkBind (lib.attrValues runOrRaiseApps))}

    # Screenshots
    bindsym Print         exec ${path}grim ~/Pictures/screenshots/screenshot-$(date +'%Y-%m-%d-%H%M%S').png
    bindsym Shift+Print   exec ${path}grim -g "$(${path}slurp)" ~/Pictures/screenshots/screenshot-$(date +'%Y-%m-%d-%H%M%S').png
    bindsym Control+Print exec ${path}grim -g "$(${path}slurp)" - | wl-copy

    # Actions
    ${lib.concatStringsSep "\n    " (map mkActionBind (lib.attrValues actions))}
  '';
}
