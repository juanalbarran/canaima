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
  homePath = config.home.homeDirectory;
in {
  imports = [
    sops-nix.homeManagerModules.sops
  ];
  sops = {
    age.keyFile = "${homePath}/.config/sops/age/keys.txt";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/${sshKeyName}".path = "${homePath}/.ssh/${sshKeyName}";
      "access_tokens/github_token" = {};
      "vpn/nix".path = "${homePath}/.config/openvpn/nix.conf";
    };
    templates = {
      "github-token" = {
        path = "${homePath}/.config/access_tokens/github_token";
        content = ''
          access-tokens = github.com=${config.sops.placeholder."access_tokens/github_token"}
        '';
      };
    };
  };
  nix.extraOptions = ''
    !include ${config.sops.templates."github-token".path}
  '';
  home.packages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
