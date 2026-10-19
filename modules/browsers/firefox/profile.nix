# ./modules/browsers/firefox/profile.nix
{
  flake.modules.homeManager.browsers = {
    programs.firefox.profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        # Tridactyl works best on a blank new page
        "browser.startup.homepage" = "about:blank";
        "browser.urlbar.update2.engineAliasRefresh" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
      };
      userChrome = ''
        /* No "Import Bookmarks" button on the bookmarks toolbar */
        #import-button {
          display: none !important;
        }
      '';
      bookmarks = {
        force = true;
        settings = [
          {
            name = "NixOS Search";
            keyword = "nix";
            url = "https://search.nixos.org/packages?channel=26.05";
          }
          {
            name = "Home Manager Options";
            keyword = "hm";
            url = "https://home-manager-options.extranix.com/?release=release-26.05";
          }
          {
            name = "Toolbar";
            toolbar = true;
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
  };
}
