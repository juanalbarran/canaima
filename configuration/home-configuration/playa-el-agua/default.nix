# configuration/home-configuration/playa-el-agua/default.nix
{
  imports = [
    ./packages.nix
    ./programs.nix
    # all the browsers, let's go!
    ./../../../home/modules/browsers
    # all the terminals, let's go!
    ./../../../home/modules/terminals
    # ui
    ./../../../home/modules/ui/sway
    ./../../../home/modules/ui/swaylock
    ./../../../home/modules/ui/wallpapers
    ./../../../home/modules/ui/waybar
    ./../../../home/modules/ui/wofi
    ./../../../home/modules/ui/themes
    ./../../../home/modules/kanshi # -> do i really use this?
    ./../../../home/modules/hostSpec
    ./../../../home/modules/sops
    # the good opencode
    ./../../../home/modules/ai
    # user
    ./../../../home/users/juan
    # ssh public keys
    ./ssh
  ];

  host.isNixOS = true;
  hostSpec = {
    username = "playa-el-agua";
    hostname = "playa-el-agua";
    sshKeyName = "playa-el-agua";
  };
}
