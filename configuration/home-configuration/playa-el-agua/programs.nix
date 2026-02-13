# configuration/home-configuration/playa-el-agua/programs.nix
{
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          name = "Juan Jesus";
          email = "juanjesusalbarran@gmail.com";
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
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/playa-el-agua-ed25519";
        };
      };
    };
  };
}
