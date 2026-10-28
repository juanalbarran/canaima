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
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ] (_: browser);
    };
    # Ubuntu tools rewrite mimeapps.list in place and break the symlink;
    # overwrite it on switch instead of failing checkLinkTargets
    xdg.configFile."mimeapps.list".force = lib.mkIf config.xdg.mimeApps.enable true;
  };
}
