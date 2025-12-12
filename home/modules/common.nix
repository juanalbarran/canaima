# home/modules/common.nix
{
  pkgs,
  kukenan,
  system,
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

  programs = {
    git = {
      enable = true;
      userName = "Juan Jesus";
      userEmail = "juanjesusalbarran@gmial.com";
    };

    bat.enable = true;

    bash = {
      enable = true;
      shellAliases = {
        vim = "nvim-base";
        cat = "bat";
        web = "nvim-web";
        vim-java = "nvim-java";
      };
      initExtra = ''
        fastfetch
      '';
    };
    yazi = {
      enable = true;
    };
    lazygit = {
      enable = true;
    };
  };
}
