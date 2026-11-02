# ./modules/work/gh.nix
{
  flake.modules.homeManager.work = {
    config,
    lib,
    ...
  }: let
    # gh stays logged in as the work account (keyring); personal repos under
    # ~/dev get the juanalbarran token from sops instead. A function and not a
    # wrapper, because Claude Code puts its own gh first on PATH
    token = config.sops.secrets."access_tokens/github_token".path;
  in {
    # Installed here and not through hostspec.githubUser, which would write the
    # personal token into hosts.yml over the work login
    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
    programs.bash.initExtra = lib.mkIf (config.hostspec.shell == "bash") ''
      gh() {
        case "$PWD/" in
          "$HOME/dev/"*) GH_TOKEN="$(<${token})" command gh "$@" ;;
          *) command gh "$@" ;;
        esac
      }
    '';
    programs.fish.functions.gh = lib.mkIf (config.hostspec.shell == "fish") ''
      if string match -q "$HOME/dev/*" "$PWD/"
        GH_TOKEN=(cat ${token}) command gh $argv
      else
        command gh $argv
      end
    '';
  };
}
