# home/modules/ui/themes/gtk.nix
{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "Sans";
      size = 12;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
