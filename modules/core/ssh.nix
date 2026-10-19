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
        # Aliases for remotes that need a specific account, e.g. git@github-ctwo:org/repo
        "github-nix" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/nix";
          IdentitiesOnly = "yes";
        };
        "github-ctwo" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/ctwo";
          IdentitiesOnly = "yes";
        };
        "*".AddKeysToAgent = "yes";
      };
    };
  };
}
