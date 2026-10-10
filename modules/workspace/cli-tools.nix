# ./modules/workspace/cli-tools.nix
{
  flake.modules.homeManager.workspace = {
    programs = {
      bat.enable = true;
      lazygit.enable = true;
      yazi = {
        enable = true;
        settings.mgr.show_hidden = true;
      };
    };
  };
}
