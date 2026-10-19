# ./modules/browsers/brave.nix
{
  flake.modules.homeManager.browsers = {config, ...}: {
    programs.brave = {
      enable = true;
      commandLineArgs = config.programs.google-chrome.commandLineArgs ++ ["--profile-directory=Default"];
      extensions = [{id = "hfjbmagddngcpeloejdejnfgbamkjaeg";}];
    };
  };
}
