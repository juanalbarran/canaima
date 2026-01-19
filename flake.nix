# flake.nix
{
  description = "Canaima NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    kukenan.url = "github:juanalbarran/neovim/kick";
    #kukenan.url = "github:juanalbarran/neovim/main";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    kukenan,
    nixgl,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      localSystem = system;
      overlays = [nixgl.overlay];
    };
  in {
    nixosConfigurations = {
      canaima = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit kukenan system;
        };
        modules = [
          {nixpkgs.hostPlatform = system;}
          ./hosts/configurations/canaima
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit kukenan system;
            };
          }
        ];
      };
      suckless = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit kukenan system;
        };
        modules = [
          {nixpkgs.hostPlatform = system;}
          ./hosts/configurations/suckless
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit kukenan system;
            };
          }
        ];
      };
    };
    homeConfigurations = {
      "juan" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home/users/juan];
        extraSpecialArgs = {
          inherit kukenan system;
        };
      };
      "nix" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home/users/nix];
        extraSpecialArgs = {
          inherit kukenan system;
        };
      };
    };
  };
}
