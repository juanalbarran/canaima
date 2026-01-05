# home/modules/browsers/firefox/default.nix
{pkgs, ...}: {
  imports = [
    ./profiles.nix
    ./extensions.nix
    ./policies.nix
  ];
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };
  home.file = {
    ".mozilla/native-messaging-hosts/tridactyl.json".source = "${pkgs.tridactyl-native}/lib/mozilla/native-messaging-hosts/tridactyl.json";
  };
}
