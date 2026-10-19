# ./modules/work/openvpn.nix
{
  flake.modules.homeManager.work = {
    config,
    lib,
    pkgs,
    ...
  }: {
    # Ubuntu's NetworkManager loads its own OpenVPN plugin (apt), so Nix only
    # brings the CLI; the shell's VPN pane toggles the connection with nmcli
    home.packages = [pkgs.openvpn];
    sops.secrets."vpn/nix".path = "${config.xdg.configHome}/openvpn/nix.conf";
    # nxvpn-ng keeps its password in a secret agent (password-flags=1), and
    # the pane's nmcli can't prompt. nm-applet is that agent: it reads the
    # password from gnome-keyring or asks for it in a dialog
    ui.startup = ["${lib.getExe' pkgs.networkmanagerapplet "nm-applet"} --indicator"];
  };
}
