# ./modules/workspace/multiplexer.nix
{
  flake.modules.homeManager.multiplexer = {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
    };
  };
}
