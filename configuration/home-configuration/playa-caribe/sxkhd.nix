# confiuration/home-configutation/playa-caribe/sxkhd.nix
{
  services.sxhkd = {
    enable = true;
    
    keybindings = {
      # Standard launch bindings
      "alt + Shift + q" = "st";
      "alt + d" = "system-menu";
      "alt + p" = "projects";
      "alt + m" = "bookmarks";

      # Run or Raise bindings
      "alt + a" = "xdotool search --class 'brave-browser' windowactivate || brave --app=https://gemini.google.com/";
      "alt + b" = "xdotool search --class 'qutebrowser' windowactivate || qutebrowser";
      "alt + q" = "xdotool search --class 'st' windowactivate || st";

      # Reload sxhkd configuration on the fly
      "alt + Escape" = "pkill -USR1 -x sxhkd";
    };
  };
}
