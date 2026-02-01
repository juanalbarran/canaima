# home/users/suckless/programs.nix
{pkgs, ...}:
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
  };

gtk = {
    enable = true;
    theme = {
	name = "Adwaita";
	package = pkgs.gnome-themes-extra;
    };
  };
}
