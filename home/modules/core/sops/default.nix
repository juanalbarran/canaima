# home/modules/core/sops/default.nix
{
  pkgs,
  inputs,
  config,
  ...
}: let
  secretsPath = toString inputs.secrets;
  sshKeyName = config.hostSpec.sshKeyName;
  email = config.hostSpec.email;
  username = config.hostSpec.username;
  homePath = config.home.homeDirectory;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    age.keyFile = "${homePath}/.config/sops/age/keys.txt";
    #age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    defaultSopsFile = "${secretsPath}/secrets.yaml";
    validateSopsFiles = false;

    secrets = {
      "private_keys/${sshKeyName}" = {
        #owner = "${username}";
        path = "${homePath}/.ssh/${sshKeyName}";
        mode = "0400";
      };
      "access_tokens/github_token" = {};
      "work/email" = {};
      "personal/email" = {};
      "vpn/nix".path = "${homePath}/.config/openvpn/nix.conf";
      "access_tokens/wireguard/private_key" = {};
      "access_tokens/wireguard/preshared_key" = {};
    };
    templates = {
      "github-token" = {
        path = "${homePath}/.config/access_tokens/github_token";
        content = ''
          access-tokens = github.com=${config.sops.placeholder."access_tokens/github_token"}
        '';
      };
      "git-email" = {
        path = "${homePath}/.config/git/sops-data.conf";
        content = ''
          [user]
            email = ${config.sops.placeholder.${email}}
        '';
      };
      "wg0.conf" = {
        path = "${homePath}/.config/wireguard/wg0.conf";
        content = ''
          [Interface]
          PrivateKey = ${config.sops.placeholder."access_tokens/wireguard/private_key"}
          Address = 100.86.156.135/32,fd00::3f:2c7a/128
          MTU = 1280
          DNS = 1.1.1.1,1.0.0.1

          [Peer]
          PresharedKey = ${config.sops.placeholder."access_tokens/wireguard/preshared_key"}
          PublicKey = BjvkHcoku8s7pf1DuqJpVccDqaj8UaOCphRBrtULWVQ=
          AllowedIPs = 0.0.0.0/0,::/0
          Endpoint = fzn.ctwo.cloud:51820
          PersistentKeepalive = 25
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
