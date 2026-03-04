# home/users/nix/packages.nix
{
  pkgs,
  kukenan,
  ...
}: let
  kuks = kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim.base;
  kuks-web = kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim.web;
in {
  home.packages = with pkgs; [
    ripgrep
    tree
    gcc
    # dev editor
    kuks
    kuks-web
    # font
    nerd-fonts.jetbrains-mono
    powertop
    # developer environment
    devenv
  ];
}
