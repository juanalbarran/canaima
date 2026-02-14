# configuration/home-configuration/playa-el-yaque/ssh/default.nix
{
  home.file.".ssh/playa-el-yaque.pub".source = ./playa-el-yaque.pub;
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/playa-el-yaque";
      };
    };
  };
}
