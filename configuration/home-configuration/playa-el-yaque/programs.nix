# configuration/home-configuration/playa-el-yaque/programs.nix
{
  programs = {
    home-manager.enable = true;
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
  };
  home.sessionVariables = {
    EDITOR = "nvim-base";
    VISUAL = "nvim-base";
  };
}
