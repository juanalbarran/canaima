# home/modules/ai/default.nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    opencode
  ];
}
