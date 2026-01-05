# home/modules/browsers/firefox/profiles.nix
{
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;

    settings = {
      # These settings help Tridactyl work smoother
      "browser.startup.homepage" = "about:blank";
      "browser.urlbar.update2.engineAliasRefresh" = true;
      # To always show the toolbar
      "browser.toolbars.bookmarks.visibility" = "always";
    };

    userChrome = ''
      /* Hide the "Import Bookmarks" button in the bookmarks toolbar */
      #import-button {
        display: none !important;
      }

      /* Optional: Hide the "Getting Started" bookmark if it appears */
      #getting-started=bookmark {
        display: none !important;
      }
    '';

    # Native-style Bookmarks (These appear directly on the bar, not in a folder)
    bookmarks = {
      force = true;
      settings = [
        {
          name = "NixOS Search";
          tags = ["nix"];
          keyword = "nix";
          url = "https://search.nixos.org/packages";
        }
        {
          name = "Home Manager Options";
          tags = ["nix"];
          keyword = "nix";
          url = "https://home-manager-options.extranix.com/";
        }
        {
          name = "Toolbar Folder";
          toolbar = true; # <--- This puts the folder on the toolbar
          bookmarks = [
            {
              name = "";
              url = "https://youtube.com";
            }
            {
              name = "";
              url = "https://github.com";
            }
          ];
        }
      ];
    };
  };
}
