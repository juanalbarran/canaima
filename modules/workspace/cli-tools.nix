# ./modules/workspace/cli-tools.nix
{
  flake.modules.homeManager.workspace = {pkgs, ...}: {
    home.packages = [pkgs.tree];
    programs = {
      bat.enable = true;
      ripgrep.enable = true;
      lazygit.enable = true;
      yazi = {
        enable = true;
        settings.mgr.show_hidden = true;
      };
    };
  };
}
