{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    obsidian
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
        vim = "nvim";
      };
    };
  };

}
