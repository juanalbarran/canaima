# home/modules/core/packages.nix
{
  pkgs,
  inputs,
  ...
}: let
  kuks = inputs.kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim.base;
  kuks-web = inputs.kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim.web;
  kuks-salesforce = inputs.kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim.salesforce;
in {
  home.packages = with pkgs; [
    ripgrep
    tree
    gcc
    # editor
    kuks
    kuks-web
    kuks-salesforce
    # development
    devenv
    # fonts
    nerd-fonts.jetbrains-mono
  ];
}
