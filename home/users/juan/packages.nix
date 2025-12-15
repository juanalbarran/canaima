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
    jq
    # dev editor
    tmux
    kuks
    kuks-web
    # wallpaper
    swww
    # screenshots
    grim
    slurp
    fastfetch
  ];
}
