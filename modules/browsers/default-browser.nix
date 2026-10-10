# ./modules/browsers/default-browser.nix
{
  flake.modules.homeManager.browsers = {
    config,
    lib,
    ...
  }: let
    browser = config.hostspec.defaultBrowser;
  in {
    # Where xdg-open sends links and HTML files: foot, chatterino, etc.
    xdg.mimeApps = lib.mkIf (browser != null) {
      enable = true;
      defaultApplications = lib.genAttrs [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ] (_: browser);
    };
  };
}
