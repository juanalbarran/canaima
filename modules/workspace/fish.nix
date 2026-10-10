# ./modules/workspace/fish.nix
{
  flake.modules.homeManager.workspace = {config, ...}: let
    fish = "${config.programs.fish.package}/bin/fish";
  in {
    # bash stays the login shell (POSIX, for /etc/profile and friends);
    # fish is what foot and tmux start for interactive use
    programs.bash.enable = true;
    programs.fish.enable = true;
    programs.foot.settings.main.shell = fish;
    programs.tmux.shell = fish;
  };
}
