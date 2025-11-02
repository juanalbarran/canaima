# home/modules/extras/default.nix
{
  home.file.".config/containers/policy.json" = {
    source = ./policy.json;
    recursive = true;
  };
}
