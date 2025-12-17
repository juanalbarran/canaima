# home/users/nix/programs.nix
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Juan Albarran";
          email = "juan.albarran@nixs.com";
        };
      };
    };

    bat.enable = true;

    bash = {
      enable = true;
      shellAliases = {
        vim = "nvim-base";
        cat = "bat";
        wvim = "nvim-web";
        jvim = "nvim-java";
        nvim = "nvim-max";
      };
      initExtra = ''
        fastfetch
      '';
    };

    yazi.enable = true;
    lazygit.enable = true;
    canaima-quickshell = {
      enable = true;
      variant = "sway";
      withNixGL = true;
    };
    canaima-wallpapers = {
      enable = true;
      withNixGL = true;
    };
  };
}
