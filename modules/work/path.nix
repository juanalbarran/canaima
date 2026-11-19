# ./modules/work/path.nix
{
  flake.modules.homeManager.work = {
    # pipx/curl installers drop their tools in ~/.local/bin
    home.sessionPath = ["$HOME/.local/bin"];
  };
}
