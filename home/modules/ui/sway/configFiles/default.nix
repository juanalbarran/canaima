# home/modules/ui/sway/config/default.nix
{
  config,
  lib,
  ...
}: let
  terminal = config.hostSpec.terminal;
  terminalAppId = config.hostSpec.terminalAppId;
  isNixOS = config.hostSpec.isNixOS;
  path =
    if isNixOS
    then ""
    else "$HOME/.nix-profile/bin/";
in {
  xdg.configFile = {
    "sway/config" = lib.mkForce {source = ./config;};
    "sway/variables.conf".text = ''
      # Mod key. Use Mod1 for Alt. Use Mod4 for Logo
      set $mod Mod4

      # Home row direction keys, like vim
      set $left h
      set $down j
      set $up k
      set $right l

      # swaymsg needs full path — sway's exec environment only has the system PATH
      set $swaymsg ${path}swaymsg

      # _id variants BEFORE base names — prevents sway prefix-match substitution bug

      set $aux_term_id com.mitchellh.ghostty
      set $aux_term ghostty
      bindsym $mod+Shift+q exec $swaymsg '[app_id="$aux_term_id"] focus' || exec $aux_term

      set $term_id ${terminalAppId}
      set $term ${path}${terminal}
      bindsym $mod+q exec $swaymsg '[app_id="$term_id"] focus' || exec $term

      set $ai_id FFPWA-01KS5C2YJE85WR6YP8K4Q584CZ
      set $ai ${path}firefoxpwa site launch 01KS5C2YJE85WR6YP8K4Q584CZ
      bindsym $mod+a exec $swaymsg '[app_id="$ai_id" title="Gemini"] focus' || exec $ai

      set $browser_id org.qutebrowser.qutebrowser
      set $browser env QT_QUICK_BACKEND=software ${path}qutebrowser --target window
      bindsym $mod+b exec $swaymsg '[app_id="$browser_id"] focus' || exec $browser

      set $slack_id Slack
      set $slack ${path}slack
      bindsym $mod+s exec $swaymsg '[app_id="$slack_id"] focus' || exec $slack

      set $chrome_id google-chrome
      set $chrome ${path}google-chrome-stable
      bindsym $mod+g exec $swaymsg '[app_id="$chrome_id"] focus' || exec $chrome

      set $firefox_id firefox
      set $firefox ${path}firefox
      bindsym $mod+f exec $swaymsg '[app_id="$firefox_id"] focus' || exec $firefox

      set $menu ${path}system-menu
      set $bookmarks ${path}bookmarks
      set $keybinds ${path}keybinds
      set $projects ${path}projects
      set $projects_ctwo ${path}projects-ctwo
      set $toggleTheme ${path}toggle-theme
      set $wallpaper ${path}wallpaper > /tmp/wallpaper-debug.log 2>&1

      set $grim ${path}grim
      set $slurp ${path}slurp
      bindsym Print exec $grim ~/Pictures/screenshots/screenshot-$(date +'%Y-%m-%d-%H%M%S').png
      bindsym Shift+Print exec $grim -g "$($slurp)" ~/Pictures/screenshots/screenshot-$(date +'%Y-%m-%d-%H%M%S').png
      bindsym Control+Print exec $grim -g "$($slurp)" - | wl-copy

      set $lock swaylock

      bindsym $mod+Shift+f exec $swaymsg '[class="Factorio" title="Factorio"] focus' || exec ~/games/factorio/bin/x64/factorio
    '';
    "sway/autostart.conf".source = ./autostart.conf;
    "sway/bindings.conf".source = ./bindings.conf;
    "sway/monitors.conf".source = ./monitors.conf;
    "sway/rules.conf".source = ./rules.conf;
  };
}
