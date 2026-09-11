# ./modules/fonts.nix
{
  flake.modules.nixos.core = {pkgs, ...}: {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
  flake.modules.homeManager.core = {pkgs, ...}: {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
}
