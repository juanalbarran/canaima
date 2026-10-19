# ./modules/browsers/firefox/firefox.nix
{
  flake.modules.homeManager.browsers = {pkgs, ...}: {
    programs.firefox = {
      enable = true;
      # Home Manager 26.05 moved the default to ~/.config/mozilla/firefox, but
      # Firefox keeps using ~/.mozilla while it exists, and the profile is there
      configPath = ".mozilla/firefox";
      # Native apps the extensions talk to: PWAs for Firefox and Tridactyl
      nativeMessagingHosts = with pkgs; [firefoxpwa tridactyl-native];
    };
    xdg.configFile."tridactyl/tridactylrc".text = ''
      " Same keys as tmux windows and qutebrowser tabs
      bind <A-Shift-[> tabprev
      bind <A-Shift-]> tabnext
      bind <C-Shift-[> tabprev
      bind <C-Shift-]> tabnext
    '';
  };
}
