# configuration/home-configuration/playa-caribe/default.nix
{
  imports = [
    # config
    ./../../../home/modules/core
    # browsers
    ./../../../home/modules/browsers/qutebrowser
    ./../../../home/modules/browsers/brave.nix
    # terminal tools
    ./../../../home/modules/terminals/tmux
    ./../../../home/modules/terminals/fastfetch
    ./../../../home/modules/terminals/starship
    ./../../../home/modules/terminals/foot
    # ui
    ./../../../home/modules/ui/themes
    # menu
    ./../../../home/modules/ui/wmenu
    ./../../../home/modules/ui/wofi
    # user
    ./../../../home/users/juan
  ];
  hostSpec = {
    username = "juan";
    fullname = "Juan Jesus Albarran Rodriguez";
    email = "personal/email";
    hostname = "sarisarinama";
    sshKeyName = "playa-caribe";
  };
}
