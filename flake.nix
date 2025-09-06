# flake.nix

{
  description = "Canaima NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        canaima = nixpkgs.lib.nixosSystem {
	  inherit system;
	  modules = [
	    ./hosts/configuration.nix
	    home-manager.nixosModules.home-manager
	    {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      
	      home-manager.users.juan = import ./home/home.nix;
	    }
	  ];
        };
      };
    };
}
