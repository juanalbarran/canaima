# home/modules/browsers/firefox/default.nix
{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./profiles.nix
    ./extensions.nix
    ./policies.nix
  ];
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts = [pkgs.firefoxpwa];
  };
  home.packages = [pkgs.firefoxpwa];
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
  home.file = {
    ".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
  };
  xdg.configFile."tridactyl/tridactylrc".text = ''
    " Bind Next/Prev tab to Ctrl+Shift+[ and ]
    bind <C-Shift-[> tabprev
    bind <C-Shift-]> tabnext

    " Alternative: If you prefer Alt+Shift
    bind <A-Shift-[> tabprev
    bind <A-Shift-]> tabnext

    " Unbind standard keys if they conflict (Optional)
    " unbind J
    " unbind K
  '';
  home.activation.firefoxpwaUserChrome = lib.hm.dag.entryAfter ["writeBoundary"] ''
      for profile_dir in "$HOME/.local/share/firefoxpwa/profiles"/*/; do
        [ -d "$profile_dir" ] || continue
        mkdir -p "$profile_dir/chrome"
        cat > "$profile_dir/chrome/userChrome.css" << 'CHROMECSS'
    #nav-bar { visibility: collapse !important; }
    #TabsToolbar { visibility: collapse !important; }
    CHROMECSS
        grep -qF 'legacyUserProfileCustomizations' "$profile_dir/user.js" 2>/dev/null || \
          echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' \
            >> "$profile_dir/user.js"
      done
  '';
}
