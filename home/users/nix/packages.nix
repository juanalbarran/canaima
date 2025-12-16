# home/users/nix/packages.nix
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
    jq
    # dev editor
    kuks
    kuks-web
    # extra
    fastfetch
    # font
    nerd-fonts.jetbrains-mono
  ];
}
