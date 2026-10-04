# home/modules/games/default.nix
{pkgs-unstable, ...}: {
  imports = [
    ./gpu-32.nix
  ];
  # Lutris installs Battle.net (and so World of Warcraft) through its own
  # Wine/DXVK/VKD3D runners. Its nixpkgs package is an FHS sandbox, so the
  # downloaded Windows binaries find the libraries they expect.
  # From unstable: the Lutris servers reject clients older than their current release.
  home.packages = [pkgs-unstable.lutris];
}
