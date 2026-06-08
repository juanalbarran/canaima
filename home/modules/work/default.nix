{pkgs, ...}: {
  imports = [
    ./wireguard
    ./1password
  ];
  home.packages = with pkgs; [
    slack
  ];
  home.sessionPath = [
    "$HOME/.ctwo/bin"
    "$HOMR/.local/bin"
  ];
}
