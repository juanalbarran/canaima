{pkgs, ...}: {
  imports = [
    ./wireguard
    ./1password
  ];
  home.packages = with pkgs; [
    slack
  ];
}
