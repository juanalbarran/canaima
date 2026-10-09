# ./modules/workspace/editor.nix
{inputs, ...}: {
  flake.modules.homeManager.editor = {pkgs, ...}: let
    kukenan = inputs.kukenan.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
  in {
    home.packages = [
      kukenan.base
      kukenan.web
      kukenan.rust
      kukenan.java
    ];
    home.sessionVariables = {
      EDITOR = "nvim-base";
      VISUAL = "nvim-base";
    };
  };
}
