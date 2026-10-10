# ./modules/core/ssh.nix
{
  flake.modules.nixos.core = {
    services.openssh.enable = true;
    programs.ssh.startAgent = true;
  };
  flake.modules.homeManager.core = {config, ...}: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/${config.hostspec.sshKeyName}";
        };
        "*".AddKeysToAgent = "yes";
      };
    };
  };
}
