# home/users/juan/packages.nix
{
  pkgs,
  kukenan,
  ...
}: let
  kuks = kukenan.packages.${pkgs.system}.neovim.base;
  kuks-web = kukenan.packages.${pkgs.system}.neovim.web;
in {
  home.packages = with pkgs; [
    ripgrep
    tree
    gcc
    waybar
    hyprlock
    jq
    # dev editor
    tmux
    kuks
    kuks-web
    # screenshots
    grim
    slurp
    fastfetch
    # browsers
    brave
  ];
}
