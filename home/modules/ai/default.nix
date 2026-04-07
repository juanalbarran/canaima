# home/modules/ai/default.nix
{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    opencode
    inputs.nix-claude-code.packages.${system}.default
  ];
}
