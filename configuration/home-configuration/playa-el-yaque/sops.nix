# configuration/home-configuration/playa-el-yaque/sops.nix
{inputs, ...}: let
  secretsPath = toString inputs.secrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    age.keyFile = "/home/juan-albarran/.config/sops/age/keys.txt";
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/playa-el-yaque" = {
        path = "/home/juan-albarran/.ssh/playa-el-yaque";
      };
    };
  };
}
