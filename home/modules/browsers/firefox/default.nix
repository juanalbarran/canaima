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
  xdg.configFile."tridactyl/tridactylrc".text = ''
    " Bind Next/Prev tab to Ctrl+Shift+[ and ]
    bind <C-Shift-[> tabprev
    bind <C-Shift-]> tabnext

    " Alternative: If you prefer Alt+Shift
    bind <A-Shift-[> tabprev
    bind <A-Shift-]> tabnext

    " Unbind standard keys if they conflict (Optional)
    " unbind J
    " unbind K
  '';
}
