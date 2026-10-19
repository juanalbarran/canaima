# ./modules/core/generic-linux.nix
{
  flake.modules.homeManager.core = {
    config,
    lib,
    ...
  }: {
    # Nix apps on another distro: XDG_DATA_DIRS, terminfo, locales, and the
    # GPU drivers at /run/opengl-driver that quickshell and mpv need
    targets.genericLinux.enable = !config.hostspec.isNixOS;
  };
}
