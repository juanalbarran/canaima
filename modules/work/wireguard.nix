# ./modules/work/wireguard.nix
{
  flake.modules.homeManager.work = {
    config,
    pkgs,
    ...
  }: let
    secret = name: config.sops.placeholder."access_tokens/wireguard/${name}";
  in {
    home.packages = [pkgs.wireguard-tools];
    sops.secrets = {
      "access_tokens/wireguard/private_key" = {};
      "access_tokens/wireguard/preshared_key" = {};
    };
    # Brought up by hand: sudo wg-quick up ~/.config/wireguard/wg0.conf
    sops.templates."wg0.conf" = {
      path = "${config.xdg.configHome}/wireguard/wg0.conf";
      content = ''
        [Interface]
        PrivateKey = ${secret "private_key"}
        Address = 100.86.156.135/32,fd00::3f:2c7a/128
        MTU = 1280
        DNS = 1.1.1.1,1.0.0.1

        [Peer]
        PresharedKey = ${secret "preshared_key"}
        PublicKey = BjvkHcoku8s7pf1DuqJpVccDqaj8UaOCphRBrtULWVQ=
        AllowedIPs = 0.0.0.0/0,::/0
        Endpoint = fzn.ctwo.cloud:51820
        PersistentKeepalive = 25
      '';
    };
  };
}
