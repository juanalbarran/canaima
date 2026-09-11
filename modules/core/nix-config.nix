# ./modules/core/nix-config.nix
{
  flake.modules.nixos.core = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = true;
  };
  flake.modules.homeManager.core = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
