# home/modules/terminals/tmux/default.nix
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
