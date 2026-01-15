# flake.nix
{
  description = "Canaima NixOS configuration with Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    kukenan.url = "github:juanalbarran/neovim/kick";
    #kukenan.url = "github:juanalbarran/neovim/main";
    ghostty = {
      url = "github:ghostty-org/ghostty/v1.2.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    kukenan,
    ghostty,
    nixgl,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [nixgl.overlay];
    };
  in {
    nixosConfigurations = {
      canaima = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit kukenan system ghostty;
        };
        modules = [
          ./hosts/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit kukenan system ghostty;
            };
          }
        ];
      };
    };
    nixosConfigurations = {
      suckless = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit kukenan system ghostty;
        };
        modules = [
          ./hosts/configurations/suckless
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit kukenan system ghostty;
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
          inherit kukenan system ghostty;
        };
      };
      "nix" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home/users/nix];
        extraSpecialArgs = {
          inherit kukenan system ghostty;
        };
      };
    };
  };
}
