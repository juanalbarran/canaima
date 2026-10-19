# ./modules/browsers/firefox/extensions.nix
{
  flake.modules.homeManager.browsers = {lib, ...}: let
    # The short id is the addons.mozilla.org URL slug; the uuid is
    # browser_specific_settings.gecko.id in the XPI's manifest.json
    extension = shortId: uuid:
      lib.nameValuePair uuid {
        install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
        installation_mode = "normal_installed";
      };
    blocked = {installation_mode = "blocked";};
  in {
    programs.firefox.policies = {
      ExtensionUpdate = true;
      ExtensionSettings =
        lib.listToAttrs [
          # Privacy / security
          (extension "noscript" "{73a6fe31-595d-460b-a920-fcc0f8843232}")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "ignore-cookies" "jid1-KKzOGWgsW3Ao4Q@jetpack")
          (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
          (extension "proton-vpn-firefox-extension" "vpn@proton.ch")
          (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
          (extension "cookie-autodelete" "CookieAutoDelete@kennydo.com")
          # Navigation
          (extension "tridactyl-vim" "tridactyl.vim@cmcaine.co.uk")
          # Layout
          (extension "tree-style-tab" "treestyletab@piro.sakura.ne.jp")
          (extension "darkreader" "addon@darkreader.org")
          (extension "domain-in-title" "{966515fa-4c81-4afe-9879-9bbaf8576390}")
          # Misc
          (extension "s3download-statusbar" "{6913849f-c79f-4f3e-83e4-890d91ad6154}")
          (extension "auto-tab-discard" "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}")
          (extension "reddit-enhancement-suite" "jid1-xUfzOsOFlzSOXg@jetpack")
          (extension "pwas-for-firefox" "{d422b427-bfec-4fc5-8c6e-e63feee3a5fe}")
        ]
        # No built-in search engines but DuckDuckGo
        // lib.genAttrs [
          "amazondotcom@search.mozilla.org"
          "bing@search.mozilla.org"
          "ebay@search.mozilla.org"
          "google@search.mozilla.org"
        ] (_: blocked);
    };
  };
}
