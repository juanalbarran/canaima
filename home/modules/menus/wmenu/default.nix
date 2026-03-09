# home/modules/ui/wmenu/default.nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    wmenu
  ];
}
