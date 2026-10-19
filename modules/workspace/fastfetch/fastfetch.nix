# ./modules/workspace/fastfetch/fastfetch.nix
{
  flake.modules.homeManager.workspace = {
    config,
    lib,
    ...
  }: {
    imports = [./_modules.nix];
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "small";
          padding = {
            top = 2;
            left = 5;
          };
        };
        display.separator = " ";
      };
    };
    # Every new interactive shell shows it, as bash did on main
    programs.fish.functions.fish_greeting = "fastfetch";
    programs.bash.initExtra = lib.mkIf (config.hostspec.shell == "bash") "fastfetch";
  };
}
