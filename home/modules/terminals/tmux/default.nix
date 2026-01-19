# home/modules/terminals/tmux/default.nix
{pkgs, ...}: let
  canaima-session = pkgs.writeShellScriptBin "canaima-session" (builtins.readFile ./scripts/canaima-session.sh);
in {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    extraConfig = builtins.readFile ./tmux.conf;
  };
  home.packages = [canaima-session];
}
