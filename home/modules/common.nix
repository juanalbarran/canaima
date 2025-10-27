# home/modules/common.nix
{
  pkgs,
  kukenan,
  system,
  ...
}:
let
  kuks = kukenan.packages.${pkgs.system}.neovim.max;
in
{
  home.packages = with pkgs; [
    ripgrep
    gemini-cli
    nodejs
    tree
    gcc
    kuks
    waybar
    swww
  ];

  programs = {
    git = {
      enable = true;
      userName = "Juan Jesus";
      userEmail = "juanjesusalbarran@gmial.com";
    };

    starship.enable = true;
    bat.enable = true;

    bash = {
      enable = true;
      shellAliases = {
        vim = "nvim-max";
        cat = "bat";
      };
    };
  };
}
