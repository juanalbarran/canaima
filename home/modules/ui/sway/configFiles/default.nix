# home/modules/ui/sway/config/default.nix
{config, ...}: let
  terminal = config.hostSpec.terminal;
  terminalAppId = config.hostSpec.terminalAppId;
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

      set $term $HOME/.nix-profile/bin/${terminal}
      set $term_id ${terminalAppId}

      set $menu $HOME/.nix-profile/bin/system-menu
      set $bookmarks $HOME/.nix-profile/bin/bookmarks
      set $keybinds $HOME/.nix-profile/bin/keybinds
      set $projects $HOME/.nix-profile/bin/projects
      set $toggleTheme $HOME/.nix-profile/bin/toggle-theme
      set $wallpaper $HOME/.nix-profile/bin/wallpaper > /tmp/wallpaper-debug.log 2>&1

      set $lock swaylock
    '';
    "sway/autostart.conf".source = ./autostart.conf;
    "sway/bindings.conf".source = ./bindings.conf;
    "sway/monitors.conf".source = ./monitors.conf;
    "sway/rules.conf".source = ./rules.conf;
  };
}
