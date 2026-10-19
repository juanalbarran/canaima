# ./modules/work/path.nix
{
  flake.modules.homeManager.work = {lib, ...}: {
    # pipx/curl installers drop their tools in ~/.local/bin
    home.sessionPath = ["$HOME/.local/bin"];
    # CTWO's CLI tools, e.g. its claude shim that prints the CTWO banner and
    # then runs the real claude, so the directory must come first. Added after
    # genericLinux's nix.sh, which puts ~/.nix-profile/bin in front of
    # everything home.sessionPath adds
    home.sessionVariablesExtra = lib.mkAfter ''
      export PATH="$HOME/.ctwo/bin''${PATH:+:}$PATH"
    '';
  };
}
