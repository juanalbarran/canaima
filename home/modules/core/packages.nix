# home/modules/core/packages.nix
{
  pkgs,
  inputs,
  ...
}: let
  kuks = inputs.kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim.base;
  kuks-web = inputs.kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim.web;
  kuks-rust = inputs.kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim.rust;
in {
  home.packages = with pkgs; [
    ripgrep
    tree
    gcc
    # editor
    kuks
    kuks-web
    kuks-rust
    # development
    devenv
    # fonts
    nerd-fonts.jetbrains-mono
  ];
}
