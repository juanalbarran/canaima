# home/modules/core/programs.nix
{config, ...}: let
  fullname = config.hostSpec.fullname;
in {
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    lazygit.enable = true;
    git = {
      enable = true;
      includes = [
        {path = config.sops.templates."git-email".path;}
      ];
      settings = {
        user = {
          name = "${fullname}";
        };
      };
    };
    bash = {
      enable = true;
      shellAliases = {
        vim = "nvim-web";
        cat = "bat";
        jvim = "nvim-java";
        nvim = "nvim-max";
      };
      initExtra = ''
        fastfetch
      '';
    };
    yazi = {
      enable = true;
      settings = {
        manager = {
          show_hidden = true;
        };
      };
    };
  };
  home.sessionVariables = {
    EDITOR = "nvim-base";
    VISUAL = "nvim-base";
  };
}
