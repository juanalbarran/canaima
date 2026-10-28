# ./modules/browsers/_re-start-settings.nix
# re-start's settings that Nix owns, for the builds qutebrowser and Brave use;
# keys as in defaultSettings (src/lib/stores/settings-store.svelte.js). icon is
# a simple-icons slug (https://simpleicons.org), "" for an arrow
{
  linksPerColumn = 4;
  links = [
    {
      title = "github";
      url = "https://github.com/juanalbarran";
      icon = "github";
      hotkey = "";
    }
    {
      title = "nixos search";
      url = "https://search.nixos.org/packages?channel=26.05";
      icon = "nixos";
      hotkey = "";
    }
    {
      title = "hm options";
      url = "https://home-manager-options.extranix.com/?release=release-26.05";
      icon = "nixos";
      hotkey = "";
    }
    {
      title = "nixos wiki";
      url = "https://wiki.nixos.org";
      icon = "nixos";
      hotkey = "";
    }
    {
      title = "gmail";
      url = "https://gmail.com";
      icon = "gmail";
      hotkey = "";
    }
    {
      title = "youtube";
      url = "https://youtube.com";
      icon = "youtube";
      hotkey = "";
    }
    {
      title = "reddit";
      url = "https://reddit.com";
      icon = "reddit";
      hotkey = "";
    }
    {
      title = "twitch";
      url = "https://twitch.tv";
      icon = "twitch";
      hotkey = "";
    }
    {
      title = "tony";
      url = "https://tonybtw.com";
      icon = "";
      hotkey = "";
    }
  ];
}
