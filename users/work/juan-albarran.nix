# ./users/work/juan-albarran.nix
{
  flake.modules.homeManager.juan-albarran = {config, ...}: {
    home = {
      username = "juan-albarran";
      homeDirectory = "/home/juan-albarran";
      stateVersion = config.hostspec.stateVersion;
    };
  };
}
