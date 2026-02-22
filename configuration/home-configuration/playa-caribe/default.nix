# configuration/home-configuration/playa-caribe/default.nix
{
  imports = [
    ./packages.nix
    ./programs.nix
    ./sxkhd.nix
    # browsers
    ./../../../home/modules/browsers/qutebrowser
    ./../../../home/modules/browsers/brave.nix
    # terminal tools
    ./../../../home/modules/terminals/tmux
    ./../../../home/modules/terminals/fastfetch
    ./../../../home/modules/terminals/starship
    ./../../../home/modules/terminals/st
    # menu
    ./../../../home/modules/ui/dmenu
    # user
    ./../../../home/users/juan
  ];
  hostSpec = {
    username = "playa-caribe";
    hostname = "playa-caribe";
    sshKeyName = "playa-caribe";
  };
}
