# ./modules/workspace/interactive-shell.nix
{
  flake.modules.homeManager.workspace = {
    config,
    lib,
    ...
  }: let
    fish = config.hostspec.shell == "fish";
    shell =
      if fish
      then lib.getExe config.programs.fish.package
      else lib.getExe config.programs.bash.package;
  in {
    # bash is always the login shell (POSIX, for /etc/profile and friends);
    # hostspec.shell picks what foot, ghostty and tmux start for interactive use
    programs.bash.enable = true;
    programs.fish.enable = fish;
    programs.foot.settings.main.shell = shell;
    programs.tmux.shell = shell;
    programs.ghostty.settings.command = shell;
  };
}
