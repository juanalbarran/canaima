# ./modules/workspace/gh.nix
{
  flake.modules.homeManager.workspace = {
    config,
    lib,
    ...
  }: let
    user = config.hostspec.githubUser;
    token = config.sops.placeholder."access_tokens/github_token";
  in
    lib.mkIf (user != null) {
      programs.gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };
      # The account lives in a sops template, not the store: the token is in
      # it, and every gh on PATH reads it (Claude Code brings its own gh)
      sops.templates."gh-hosts" = {
        path = "${config.xdg.configHome}/gh/hosts.yml";
        content = builtins.toJSON {
          "github.com" = {
            inherit user;
            git_protocol = "ssh";
            oauth_token = token;
            users.${user}.oauth_token = token;
          };
        };
      };
    };
}
