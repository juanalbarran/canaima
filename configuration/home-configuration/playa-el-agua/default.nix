# configuration/home-configuration/playa-el-agua/default.nix
{
  imports = [
    # core modules: gc, ssh, sops, hostSpec
    ./../../../home/modules/core
    # all the browsers, let's go!
    ./../../../home/modules/browsers
    # all the terminals, let's go!
    ./../../../home/modules/terminals
    # ui
    ./../../../home/modules/ui/sway
    ./../../../home/modules/ui/swaylock
    ./../../../home/modules/ui/wallpapers
    ./../../../home/modules/ui/waybar
    ./../../../home/modules/ui/themes
    ./../../../home/modules/kanshi # -> do i really use this?
    # menu
    ./../../../home/modules/menus/wofi
    # scripts
    ./../../../home/modules/scripts
    # the good opencode
    ./../../../home/modules/ai
    # user
    ./../../../home/users/juan
  ];

  hostSpec = {
    username = "juan";
    fullname = "Juan Jesus Albarran Rodriguez";
    email = "personal/email";
    hostname = "canaima";
    sshKeyName = "playa-el-agua";
    terminal = "foot";
    terminalAppId = "foot";
    auxTerminal = "ghostty";
    auxTerminalAppId = "com.mitchellh.ghostty";
    ai = "firefoxpwa site launch 01KS5C2YJE85WR6YP8K4Q584CZ";
    aiAppId = "FFPWA-01KS5C2YJE85WR6YP8K4Q584CZ";
    browser = "qutebrowser --target window";
    browserAppId = "org.qutebrowser.qutebrowser";
    menu = "wofi";
    isNixOS = true;
    windowManager = "sway";
  };
}
