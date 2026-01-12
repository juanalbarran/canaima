# home/modules/browsers/qutebrowser/default.nix
{
  pkgs,
  nixgl,
  ...
}: {
  programs.qutebrowser = {
    enable = true;
    quickmarks = {
      gh = "https://github.com";
      hm = "https://home-manager-options.extranix.com";
      nw = "https://nixos.wiki";
      yt = "https://youtube.com";
      rd = "https://reddit.com";
    };
    searchEngines = {
      # default (used when you just type a string)
      "default" = "https://duckduckgo.com/?q={}";

      # search nixos packages (unstable channel)
      "nix" = "https://search.nixos.org/packages?channel=unstable&query={}";

      # search home manager options
      "hm" = "https://home-manager-options.extranix.com/?query={}";

      # youtube specific search
      "y" = "https://www.youtube.com/results?search_query={}";

      # google fallback
      "g" = "https://www.google.com/search?hl=en&q={}";
    };
    settings = {
      # visuals
      "colors.webpage.darkmode.enabled" = true; # force dark mode on all sites
      "tabs.position" = "top"; # vertical tabs (better for widescreen)
      "tabs.show" = "multiple"; # hide tab bar if only 1 tab is open
      "scrolling.smooth" = true;

      # privacy & annoyances
      "content.autoplay" = false; # stop videos from auto-playing
      "content.blocking.enabled" = true; # enable built-in adblock (brave's engine)
    };

    # 4. keybindings
    keyBindings = {
      normal = {
        # power user feature: open video links in mpv (requires mpv installed)
        "m" = "hint links spawn mpv {hint-url}";
        "<ctrl-m>" = "spawn mpv {url};; tab-close";

        # vim-style tab navigation (standard j/k)
        "<Meta-Shift-{>" = "tab-prev";
        "<Meta-Shift-}>" = "tab-next";

        # toggle dark mode quickly with ',d'
        ",d" = "config-cycle colors.webpage.darkmode.enabled";
      };
    };
  };
  home.packages = with pkgs; [
    mpv # the video player
    yt-dlp # the tool mpv uses to "read" youtube/twitch urls
  ];
}
