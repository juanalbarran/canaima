# home/modules/terminals/tmux/default.nix
{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.bash}/bin/bash";
    # pairs with vim-tmux-navigator in neovim: <C-h/j/k/l> move across vim splits and tmux panes
    plugins = with pkgs.tmuxPlugins; [vim-tmux-navigator];
    extraConfig = builtins.readFile ./tmux.conf;
  };
}
