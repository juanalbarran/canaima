# home/users/juan/programs.nix
{
  programs = {
    git = {
      enable = true;
      userName = "Juan Jesus";
      userEmail = "juanjesusalbarran@gmail.com";
    };

    bat.enable = true;

    bash = {
      enable = true;
      shellAliases = {
        vim = "nvim-base";
        cat = "bat";
        wvim = "nvim-web";
        jvim = "nvim-java";
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
