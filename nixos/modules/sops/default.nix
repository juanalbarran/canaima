# nixos/modules/sops/default.nix
{
  pkgs,
  inputs,
  config,
  ...
}: let
  secretsPath = toString inputs.secrets;
  sskKeyName = config.hostSpec.sskKeyName;
in {
  sops = {
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/playa-el-agua" = {
        path = "/home/juan/.ssh/${sshKeyName}";
        owner = "juan";
        group = "users";
      };
      "access_tokens/github_token" = {
        owner = "root";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
