# ./modules/workspace/prompt.nix
{
  flake.modules.homeManager.workspace = {
    # Starship's default prompt, the same as main, in fish and bash
    programs.starship = {
      enable = true;
      # Big repos (nixpkgs…) take longer than the default 500ms for git status
      settings.command_timeout = 2000;
    };
  };
}
