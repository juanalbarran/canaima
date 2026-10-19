# ./modules/ai/claude/claude.nix
{inputs, ...}: {
  flake.modules.homeManager.ai = {pkgs, ...}: {
    programs.claude-code = {
      enable = true;
      package = inputs.nix-claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
      commands.issue = ./_commands/issue.md;
    };
    # claude-cli:// deep links. Claude Code writes the desktop file itself on
    # start, but can't add this to the mimeapps.list Home Manager owns
    xdg.mimeApps = {
      enable = true;
      defaultApplications."x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };
}
