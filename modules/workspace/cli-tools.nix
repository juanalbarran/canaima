# ./modules/workspace/cli-tools.nix
{
  flake.modules.homeManager.workspace = {pkgs, ...}: {
    home.packages = [pkgs.tree];
    # bat prints plain like cat when piped, so scripts and pipes are unaffected
    home.shellAliases.cat = "bat";
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
