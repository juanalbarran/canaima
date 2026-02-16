# configuration/home-configuration/playa-el-yaque/sops.nix
{
  inputs,
  config,
  ...
}: let
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
        path = "${config.home.homeDirectory}/.ssh/playa-el-yaque";
      };
      "access_tokens/github_token" = {};
    };
    templates = {
      "github-token" = {
        path = "${config.home.homeDirectory}/.config/access_tokens/github_token";
        content = ''
          access-tokens = github.com=${config.sops.placeholder."access_tokens/github_token"}
        '';
      };
    };
  };

  nix.extraOptions = ''
    !include ${config.sops.templates."github-token".path}
  '';
}
