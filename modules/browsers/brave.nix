# ./modules/browsers/brave.nix
{
  flake.modules.homeManager.browsers = {
    config,
    pkgs,
    ...
  }: let
    # re-start built here instead of the Web Store's, so the links come from Nix
    reStart = pkgs.callPackage ./_re-start.nix {
      browser = "chrome";
      settings = import ./_re-start-settings.nix;
    };
  in {
    programs.brave = {
      enable = true;
      commandLineArgs =
        config.programs.google-chrome.commandLineArgs
        ++ [
          "--profile-directory=Default"
          "--load-extension=${reStart}"
        ];
      extensions = [{id = "hfjbmagddngcpeloejdejnfgbamkjaeg";}];
    };
  };
}
