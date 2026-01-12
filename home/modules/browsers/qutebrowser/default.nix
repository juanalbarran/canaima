# home/modules/browsers/qutebrowser/default.nix
{pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;
    quickmarks = {
      gh = "https://github.com";
      hm = "https://home-manager-options.extranix.com";
      nw = "https://nixos.wiki";
      yt = "https://youtube.com";
      rd = "https://reddit.com";
    };
  };
  searchEngines = {
    # Default (used when you just type a string)
    "DEFAULT" = "https://duckduckgo.com/?q={}";

    # Search NixOS Packages (Unstable channel)
    "nix" = "https://search.nixos.org/packages?channel=unstable&query={}";

    # Search Home Manager Options
    "hm" = "https://home-manager-options.extranix.com/?query={}";

    # YouTube specific search
    "y" = "https://www.youtube.com/results?search_query={}";

    # Google fallback
    "g" = "https://www.google.com/search?hl=en&q={}";
  };
  settings = {
    # Visuals
    "colors.webpage.darkmode.enabled" = true; # Force dark mode on all sites
    "tabs.position" = "left"; # Vertical tabs (better for widescreen)
    "tabs.show" = "multiple"; # Hide tab bar if only 1 tab is open
    "scrolling.smooth" = true;

    # Privacy & Annoyances
    "content.autoplay" = false; # Stop videos from auto-playing
    "content.blocking.enabled" = true; # Enable built-in adblock (Brave's engine)
  };

  # 4. Keybindings
  keyBindings = {
    normal = {
      # Power User Feature: Open video links in MPV (requires mpv installed)
      "M" = "hint links spawn mpv {hint-url}";

      # Vim-style tab navigation (standard J/K)
      "J" = "tab-next";
      "K" = "tab-prev";

      # Toggle dark mode quickly with ',d'
      ",d" = "config-cycle colors.webpage.darkmode.enabled";
    };
  };
  home.packages = with pkgs; [
    mpv # The video player
    yt-dlp # The tool mpv uses to "read" youtube/twitch URLs
  ];
}
