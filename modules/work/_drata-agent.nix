# ./modules/work/_drata-agent.nix
# A package, not a flake-parts module: the _ keeps import-tree away from it
{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 {
  pname = "drata-agent";
  version = "latest";
  # "latest" moves with every release, so the hash breaks when Drata publishes one
  src = fetchurl {
    url = "https://github.com/drata/agent-releases/releases/latest/download/Drata-agent-linux.AppImage";
    sha256 = "sha256-SYjVv9lr3UPai0cbGWzEzUW0kYX6UrLOJqQQFH3O5IQ=";
  };
}
