# home/modules/ui/wofi/default.nix
{pkgs, ...}: let
  system-menu = import ./scripts/system-menu.nix {inherit pkgs;};
in {
  home.packages = [
    system-menu
  ];

  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true;
      insentive = true;
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
    };
    style = builtins.readFile ./style.css;
  };
}
