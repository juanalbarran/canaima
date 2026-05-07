# configuration/home-configuration/playa-el-yaque/drata-agent.nix
{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "drata-agent";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/drata/agent-releases/releases/latest/download/Drata-agent-linux.AppImage";
    sha256 = "sha256-SYjVv9lr3UPai0cbGWzEzUW0kYX6UrLOJqQQFH3O5IQ=";
  };
}
