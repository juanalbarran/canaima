# home/modules/common.nix
{
  pkgs,
  kukenan,
  system,
  ...
}: let
  kuks = kukenan.packages.${pkgs.system}.neovim.base;
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
    # wallpaper
    swww
    # screenshots
    grim
    slurp
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
        vim-web = "nvim-web";
        vim-java = "nvim-java";
      };
    };
    yazi = {
      enable = true;
    };
    lazygit = {
      enable = true;
    };
  };
}
