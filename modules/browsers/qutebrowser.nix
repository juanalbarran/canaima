# ./modules/browsers/qutebrowser.nix
{
  flake.modules.homeManager.browsers = {
    config,
    lib,
    ...
  }: let
    mpv = "spawn --detach ${lib.getExe config.programs.mpv.finalPackage} --force-window";
    streamlink = "spawn --detach ${lib.getExe config.programs.streamlink.package}";
  in {
    programs.qutebrowser = {
      enable = true;
      quickmarks = {
        github = "https://github.com/juanalbarran";
        home-manager-options = "https://home-manager-options.extranix.com";
        nixwiki = "https://wiki.nixos.org";
        youtube = "https://youtube.com";
        reddit = "https://reddit.com";
        twitch = "https://twitch.tv";
        tony = "https://tonybtw.com";
        gmail = "https://gmail.com";
      };
      searchEngines = {
        DEFAULT = "https://duckduckgo.com/?q={}";
        nix = "https://search.nixos.org/packages?channel=26.05&query={}";
        nixo = "https://search.nixos.org/options?channel=26.05&query={}";
        hm = "https://home-manager-options.extranix.com/?release=release-26.05&query={}";
        g = "https://www.google.com/search?hl=en&q={}";
      };
      settings = {
        tabs.position = "top";
        tabs.show = "multiple";
        scrolling.smooth = true;
        colors.webpage.darkmode.algorithm = "lightness-cielab";
        colors.webpage.darkmode.contrast = 0.0;
        content.autoplay = false;
        content.blocking.enabled = true;
      };
      # Google refuses logins from a user agent with "QtWebEngine" in it;
      # look like the Chrome this qutebrowser is built on instead.
      perDomainSettings."https://accounts.google.com/*" = {
        content.headers.user_agent = "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}";
      };
      keyBindings = {
        normal = {
          # Same keys as tmux windows: alt+shift+[ / ]
          "<Alt-Shift-{>" = "tab-prev";
          "<Alt-Shift-}>" = "tab-next";
          "<Ctrl-Alt-Shift-{>" = "tab-move -";
          "<Ctrl-Alt-Shift-}>" = "tab-move +";
          # Open a video in mpv instead of the page
          "m" = "hint links ${mpv} {hint-url}";
          "<Ctrl-m>" = "${mpv} {url};; tab-close";
          # Watch a live stream (Twitch) through streamlink, ads skipped
          ",t" = "hint links ${streamlink} {hint-url}";
          ",T" = "${streamlink} {url};; tab-close";
          ",d" = "config-cycle colors.webpage.darkmode.enabled";
        };
        command = {
          "<Ctrl-n>" = "completion-item-focus next";
          "<Ctrl-p>" = "completion-item-focus prev";
        };
      };
    };
  };
}
