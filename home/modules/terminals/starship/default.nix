# home/modules/starship/default.nix
{
  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 2000;
    };
  };
}
