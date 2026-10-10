# ./modules/core/sops.nix
{inputs, ...}: {
  flake.modules.homeManager.core = {
    config,
    pkgs,
    ...
  }: let
    home = config.home.homeDirectory;
    inherit (config.hostspec) sshKeyName emailSecret;
  in {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    sops = {
      age.keyFile = "${home}/.config/sops/age/keys.txt";
      defaultSopsFile = "${inputs.secrets}/secrets.yaml";
      validateSopsFiles = false;
      secrets = {
        "private_keys/${sshKeyName}" = {
          path = "${home}/.ssh/${sshKeyName}";
          mode = "0400";
        };
        "access_tokens/github_token" = {};
        ${emailSecret} = {};
      };
      templates = {
        "github-token" = {
          path = "${home}/.config/access_tokens/github_token";
          content = ''
            access-tokens = github.com=${config.sops.placeholder."access_tokens/github_token"}
          '';
        };
        "git-email" = {
          path = "${home}/.config/git/sops-data.conf";
          content = ''
            [user]
              email = ${config.sops.placeholder.${emailSecret}}
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
  };
}
