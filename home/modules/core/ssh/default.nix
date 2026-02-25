# home/modules/core/ssh/default.nix
{config, ...}: let
  sshKeyName = config.hostSpec.sshKeyName;
in {
  home.file.".ssh/${sshKeyName}.pub".source = ./../../../../configuration/home-configuration/${sshKeyName}/ssh/${sshKeyName}.pub;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/${sshKeyName}";
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/${sshKeyName}";
      };
    };
  };
}
