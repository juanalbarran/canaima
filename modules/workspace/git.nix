# ./modules/workspace/git.nix
{
  flake.modules.homeManager.workspace = {config, ...}: {
    programs.git = {
      enable = true;
      includes = [{path = config.sops.templates."git-email".path;}];
      settings.user.name = "Juan Jesus Albarran Rodriguez";
    };
  };
}
