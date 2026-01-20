# home/modules/terminals/tmux/default.nix
{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.bash}/bin/bash";
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
