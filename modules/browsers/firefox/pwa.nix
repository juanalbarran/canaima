# ./modules/browsers/firefox/pwa.nix
{
  flake.modules.homeManager.browsers = {
    lib,
    pkgs,
    ...
  }: {
    # PWAs for Firefox: web apps (Gemini…) in their own window and app_id,
    # launched with `firefoxpwa site launch <id>`
    home.packages = [pkgs.firefoxpwa];
    # Each PWA has its own profile, created at runtime with a random id, so
    # it's patched here instead of declared: no toolbar and no tab bar
    home.activation.firefoxpwaUserChrome = lib.hm.dag.entryAfter ["writeBoundary"] ''
      for profile in "$HOME/.local/share/firefoxpwa/profiles"/*/; do
        [ -d "$profile" ] || continue
        mkdir -p "$profile/chrome"
        cat > "$profile/chrome/userChrome.css" << 'CSS'
      #nav-bar { visibility: collapse !important; }
      #TabsToolbar { visibility: collapse !important; }
      CSS
        grep -qF 'legacyUserProfileCustomizations' "$profile/user.js" 2>/dev/null ||
          echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$profile/user.js"
      done
    '';
  };
}
