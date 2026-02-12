{inputs, ...}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    age.keyFile = "/home/juan-albarran/.config/sops/age/keys.txt";
    defaultSopsFile = inputs.secrets.outPath + "/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/playa-el-yaque" = {
        path = "/home/juan.albarran/.ssh/playa-el-yaque-ed25519";
      };
    };
  };
}
