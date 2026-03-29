# home/modules/ui/sway/config/default.nix
{config, ...}: let
  terminal = config.hostSpec.terminal;
  terminalAppId = config.hostSpec.terminalAppId;
  isNixOS = config.hostSpec.isNixOS;
  path = if isNixOS then "" else "$HOME/.nix-profile/bin/";
in {
  xdg.configFile = {
    "sway/config".source = ./config;
    "sway/variables.conf".text = ''
      # Mod key. Use Mod1 for Alt. Use Mod4 for Logo
      set $mod Mod4

      # Home row direction keys, like vim
      set $left h
      set $down j
      set $up k
      set $right l

      # Your preferred terminal emulator (Dynamically injected!)
      set $aux_term ghostty
      set $aux_term_id com.mitchellh.ghostty

      set $term ${path}${terminal}
      set $term_id ${terminalAppId}

      set $menu ${path}system-menu
      set $bookmarks ${path}bookmarks
      set $keybinds ${path}keybinds
      set $projects ${path}projects
      set $toggleTheme ${path}toggle-theme
      set $wallpaper ${path}wallpaper > /tmp/wallpaper-debug.log 2>&1

      set $ai ${path}brave --app=https://gemini.google.com/
      set $ai_id brave-gemini.google.com__-Default

      set $browser env QT_QUICK_BACKEND=software ${path}qutebrowser --target window
      set $browser_id org.qutebrowser.qutebrowser


      set $lock swaylock
    '';
    "sway/autostart.conf".source = ./autostart.conf;
    "sway/bindings.conf".source = ./bindings.conf;
    "sway/monitors.conf".source = ./monitors.conf;
    "sway/rules.conf".source = ./rules.conf;
  };
}
