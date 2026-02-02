# nixos/modules/common/default.nix
{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
  ];
  #console = {
  #  earlySetup = true;
  #  font = "${pkgs.terminus_font}/share/consolefonts/ter-u18n.psf.gz";
  #  packages = with pkgs; [terminus_font];
  #  keyMap = "us";
  #};
}
