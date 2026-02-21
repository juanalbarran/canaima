# home/modules/sops/default.nix
{
  pkgs,
  inputs,
  config,
  sops-nix,
  ...
}: let
  secretsPath = toString inputs.secrets;
  sshKeyName = config.hostSpec.sshKeyName;
in {
  imports = [
    sops-nix.homeManagerModules.sops
  ];
  sops = {
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/${sshKeyName}" = {
        path = "/home/juan/.ssh/${sshKeyName}";
      };
      "access_tokens/github_token" = {};
    };
  };
  home.packages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
