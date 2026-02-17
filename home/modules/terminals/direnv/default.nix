# home/modules/terminals/direnv/default.nix
{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
