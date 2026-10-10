# ./modules/workspace/fastfetch/fastfetch.nix
{
  flake.modules.homeManager.workspace = {
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
    # Every new fish shows it, as bash did on main
    programs.fish.functions.fish_greeting = "fastfetch";
  };
}
