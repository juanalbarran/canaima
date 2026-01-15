# hosts/modules/common/font/default.nix
{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
  ];
}
