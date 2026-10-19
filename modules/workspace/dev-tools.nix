# ./modules/workspace/dev-tools.nix
{
  flake.modules.homeManager.workspace = {pkgs, ...}: {
    home.packages = with pkgs; [
      # Per-project dev environments (devenv.nix)
      devenv
      # C compiler, nvim-treesitter builds its parsers with it
      gcc
    ];
  };
}
