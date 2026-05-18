{
  pkgs,
  inputs,
  system, # Make sure system is passed in your args if you use it for claude!
  ...
}: let
  # Create the wrapper that forces the env var just for opencode
  opencode-wrapped = pkgs.symlinkJoin {
    name = "opencode";
    paths = [pkgs.opencode];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/opencode \
        --set NODE_TLS_REJECT_UNAUTHORIZED 0
    '';
  };
in {
  home.packages = with pkgs; [
    opencode-wrapped # Use the wrapped version here!
    inputs.nix-claude-code.packages.${system}.default
    ollama
  ];
}
