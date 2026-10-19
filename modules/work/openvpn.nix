# ./modules/work/openvpn.nix
{
  flake.modules.homeManager.work = {
    config,
    pkgs,
    ...
  }: {
    # Ubuntu's NetworkManager loads its own OpenVPN plugin (apt), so Nix only
    # brings the CLI; the shell's VPN pane toggles the connection with nmcli
    home.packages = [pkgs.openvpn];
    sops.secrets."vpn/nix".path = "${config.xdg.configHome}/openvpn/nix.conf";
  };
}
