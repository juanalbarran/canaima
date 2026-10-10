# ./modules/ai/claude/claude.nix
{inputs, ...}: {
  flake.modules.homeManager.ai = {pkgs, ...}: {
    programs.claude-code = {
      enable = true;
      package = inputs.nix-claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
      commands.issue = ./_commands/issue.md;
    };
  };
}
