# ./modules/core/nix-config.nix
{
  flake.modules.nixos.core = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nixpkgs.config.allowUnfree = true;
    # qutebrowser 3.7.0 still accepts eMudhra TLS certs; nixpkgs has no newer release yet
    nixpkgs.config.permittedInsecurePackages = ["qutebrowser-3.7.0"];
  };
  flake.modules.homeManager.core = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
