# home/users/juan/programs.nix
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
    # canaima-quickshell = {
    #   enable = true;
    #   variant = "hyprland";
    #   withNixGL = false;
    # };
    canaima-wallpapers = {
      enable = true;
      withNixGL = false;
    };
  };
}
