# ./modules/work/path.nix
{
  flake.modules.homeManager.work = {
    # CTWO's own CLI tools install there, and pipx/curl installers to ~/.local/bin
    home.sessionPath = [
      "$HOME/.ctwo/bin"
      "$HOME/.local/bin"
    ];
  };
}
