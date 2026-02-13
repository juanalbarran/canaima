# nixos/modules/sops/default.nix
{
  pkgs,
  inputs,
  ...
}: let
  sopsPath = toString inputs.sops-nix.nixosModules.sops;
in {
  sops = {
    age.sshKeyPaths = ["/etc/ssh/ssh_hosts_ed25519_key"];
    defaultSopsFile = "${sopsPath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/<host-name>" = {
        path = "<home-path>/.ssh/<host-name>";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
