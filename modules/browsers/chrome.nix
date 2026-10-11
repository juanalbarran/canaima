# ./modules/browsers/chrome.nix
{
  flake.modules.homeManager.browsers = {
    programs.google-chrome.enable = true;
  };
}
