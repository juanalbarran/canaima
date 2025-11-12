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
        vim = "nvim-max";
        cat = "bat";
      };
    };
    yazi = {
      enable = true;
    };
  };
}
