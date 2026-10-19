# ./modules/work/path.nix
{
  flake.modules.homeManager.work = {lib, ...}: {
    # pipx/curl installers drop their tools in ~/.local/bin
    home.sessionPath = ["$HOME/.local/bin"];
    # CTWO's CLI tools, e.g. its claude shim that prints the CTWO banner and
    # then runs the real claude, so the directory must come first. genericLinux
    # sources nix.sh in the session vars and again in .bashrc, and each time it
    # puts ~/.nix-profile/bin in front, so ~/.ctwo/bin goes back in front after
    # both. In .bashrc the old entry is dropped first, so nested shells don't
    # pile it up
    home.sessionVariablesExtra = lib.mkAfter ''
      export PATH="$HOME/.ctwo/bin''${PATH:+:}$PATH"
    '';
    programs.bash.initExtra = lib.mkAfter ''
      PATH=":$PATH:"
      PATH="''${PATH//:$HOME\/.ctwo\/bin:/:}"
      PATH="''${PATH#:}"
      export PATH="$HOME/.ctwo/bin:''${PATH%:}"
    '';
  };
}
