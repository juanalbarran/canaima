# home/modules/core/packages.nix
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
    # editor
    kuks
    kuks-web
    # development
    devenv
    # fonts
    nerd-fonts.jetbrains-mono
  ];
}
