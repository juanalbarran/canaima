# configuration/home-configuration/playa-el-agua/ssh/default.nix
{
  home.file.".ssh/playa-el-agua.pub".source = ./playa-el-agua.pub;
}
