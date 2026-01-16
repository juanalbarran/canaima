# home/modules/browsers/qutebrowser/default.nix
{pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;
    quickmarks = {
      github = "https://github.com";
      home-manager-options = "https://home-manager-options.extranix.com";
      nixwiki = "https://nixos.wiki";
      youtube = "https://youtube.com";
      reddit = "https://reddit.com";
      twitch = "https://twitch.tv";
      tony = "https://tonybtw.com";
      gmail = "https://gmail.com";
      nixsearch = "https://search.nixos.org/packages?channel=unstable&query={}";
    };
    searchEngines = {
      # default (used when you just type a string)
      "default" = "https://duckduckgo.com/?q={}";

      # search nixos packages (unstable channel)
      "nix" = "https://search.nixos.org/packages?channel=unstable&query={}";

      # search home manager options
      "hm" = "https://home-manager-options.extranix.com/?query={}";

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

    keyBindings = {
      normal = {
        # power user feature: open video links in mpv (requires mpv installed)
        "m" = "hint links spawn --detach ${pkgs.mpv}/bin/mpv --force-window --vo=wlshm {hint-url}";
        "<ctrl-m>" = "spawn --detach ${pkgs.mpv}/bin/mpv --force-window --vo=wlshm {url};; tab-close";

        # vim-style tab navigation (standard j/k)
        "<Meta-Shift-{>" = "tab-prev";
        "<Meta-Shift-}>" = "tab-next";

        # toggle dark mode quickly with ',d'
        ",d" = "config-cycle colors.webpage.darkmode.enabled";
      };
      command = {
        "<Ctrl-n>" = "completion-item-focus next";
        "<Ctrl-p>" = "completion-item-focus prev";
      };
    };
  };
  home.packages = with pkgs; [
    mpv # the video player
    yt-dlp # the tool mpv uses to "read" youtube/twitch urls
  ];
  xdg.configFile = {
    "qutebrowser/gemini-config.py".source = ./gemini-config.py;
  };
}
