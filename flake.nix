# flake.nix

{
  description = "Canaima NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    kukenan.url = "github:juanalbarran/neovim/kick";
    #kukenan.url = "github:juanalbarran/neovim/main";
    ghostty.url = "github:ghostty-org/ghostty/v1.2.1";
  };

  outputs = { self, nixpkgs, home-manager, kukenan, ghostty, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        canaima = nixpkgs.lib.nixosSystem {
	  inherit system;
	  specialArgs = { inherit kukenan system ghostty; };
	  modules = [
	    ./hosts/configuration.nix
	    home-manager.nixosModules.home-manager
	    {
              home-manager.extraSpecialArgs = {
                inherit kukenan system;
              };
            }
	    ./home/home.nix
	  ];
        };
      };
    };
}
