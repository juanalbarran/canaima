# ./modules/work/1password.nix
{
  flake.modules.homeManager.work = {pkgs, ...}: {
    home.packages = with pkgs; [
      _1password-gui
      _1password-cli
    ];
  };
}
