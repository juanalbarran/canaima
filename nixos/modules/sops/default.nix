# nixos/modules/sops/default.nix
{
  pkgs,
  inputs,
  ...
}: let
  sopsSecretPath = toString inputs.sops-nix.nixosModules.sops;
in {
  sops = {
    age.sshKeyPaths = ["/etc/ssh/ssh_hosts_ed25519_key"];
    defaultSopsFile = "${sopsSecretPath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/playa-el-agua" = {
        path = "/home/juan/.ssh/playa-el-agua-ed25519";
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
