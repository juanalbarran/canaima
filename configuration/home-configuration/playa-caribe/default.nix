# configuration/home-configuration/playa-caribe/default.nix
{
  imports = [
    ./packages.nix
    ./programs.nix
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
    # user
    ./../../../home/users/juan
  ];
  hostSpec = {
    username = "juan";
    hostname = "playa-caribe";
    sshKeyName = "playa-caribe";
  };
}
